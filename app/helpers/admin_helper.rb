module AdminHelper

def restful_links(name_array, html_options={}, &block)
    links = []
    object = [name_array].flatten.last
    unless object.nil?
      object_name = object.new_record? ? object.class.to_s.underscore : controller.controller_name.singularize.to_s
      ajax = html_options.delete(:ajax)
      options = {
        :index => {:id => "index_#{object_name}_link", :class => 'index_link'},
        :new => {:id => "new_#{object_name}_link", :class => ajax && !%{edit}.include?(controller.action_name) ? 'h-get new_link' : 'new_link'},
        :show => {:id => "show_#{object_name}_link", :class => 'show_link'},
        :edit => {:id => "edit_#{object_name}_link", :class => ajax ? 'h-get edit_link' : 'edit_link'},
        :destroy => {:id => "destroy_#{object_name}_link", :class => ajax ? 'h-delete destroy_link' : 'destroy_link', :method => :delete, :confirm => t('common.confirms.destroy')}
      }
      options.each { |k,v| v.merge!(html_options.delete(k)) unless html_options[k].blank? }

      unless object.new_record? && !%{new}.include?(controller.action_name)
        links << link_to(t('common.actions.index'), polymorphic_path(name_array.to_a - [object] << object.class.new), options[:index]) if permitted_to?(:index)
      end
      links << link_to(t('common.actions.new'), new_polymorphic_path(name_array.to_a - [object] << object.class.new), options[:new]) if permitted_to?(:new)
      unless object.new_record?
        links << link_to_unless(%{show}.include?(controller.action_name), t('common.actions.show'), polymorphic_path(name_array), options[:show]) if permitted_to?(:show, object)
        links << link_to(t('common.actions.edit'), edit_polymorphic_path(name_array), options[:edit]) if permitted_to?(:edit, object)
        links << link_to(t('common.actions.destroy'), polymorphic_path(name_array), options[:destroy]) if permitted_to?(:destroy, object)
      end
    end
    concat_array(links, {:class => "restful_links"}.merge(html_options), &block)
  end

   def tool_links(name_array, html_options={}, &block)
    links = []
    object = [name_array].flatten.last
    unless object.nil? || object.new_record?
      object_name = object.class.to_s.underscore
      ajax = html_options.delete(:ajax)
      options = {
        :show => {:id => "show_#{object_name}_link", :class => 'show_link'},
        :edit => {:id => "edit_#{object_name}_link", :class => ajax ? 'h-get edit_link' : 'edit_link'},
        :destroy => {:id => "destroy_#{object_name}_link", :class => ajax ? 'h-delete destroy_link' : 'destroy_link', :method => :delete, :confirm => t('common.confirms.destroy')}
      }
      options.each { |k,v| v.merge!(html_options.delete(k)) unless html_options[k].blank? }
      links << link_to(t('common.actions.show'), polymorphic_path(name_array), options[:show]) #if permitted_to?(:show, object)
      links << link_to(t('common.actions.edit'), edit_polymorphic_path(name_array), options[:edit]) #if permitted_to?(:edit, object)
      links << link_to(t('common.actions.destroy'), polymorphic_path(name_array), options[:destroy]) #if permitted_to?(:destroy, object)
    end
    concat_array(links, {:class => "tool_links hide"}.merge(html_options), &block)
   end

  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end

  def auto_title
    title_parts = [controller.action_name.to_s.capitalize, controller.controller_name.singularize.to_s.capitalize]
    title_parts.reverse! if controller.action_name.to_s == 'index'
    content_tag(:h1, title_parts.join(' '), :class => 'admin')
  end
def concat_array(array, options={}, &block)
    array << capture(&block).strip! if block_given?
    array.delete('')
    array.compact!
    tag = options.delete(:tag) || :div
    output = content_tag tag, array.join(' | '), options
    concat(output)
  end

  def at(klass, attribute, options = {})
    klass.human_attribute_name(attribute.to_s, options = {})
  end
     
  def get_current(val)
    return "id=current" if controller.controller_name == val
  end
  end