ActiveAdmin.register Article do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :title, :body, :body_url, :cover, :sort, :category_id
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

form do |f|
  f.semantic_errors
  f.inputs "基本信息" do
    f.input :category_id, as: :select, collection: Category.all.map { |c| [c.name, c.id] }, prompt: '-- 选择所属分类 --'
    f.input :title
    f.input :cover
    f.input :body, as: :text, input_html: { class: 'redactor' }, placeholder: '网页内容，支持图文混排', hint: '网页内容，支持图文混排'
    f.input :body_url
    f.input :sort
  end
  f.actions
end

end
