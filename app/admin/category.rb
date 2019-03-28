ActiveAdmin.register Category do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :pid, :sort, :opened
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
    f.input :name
    f.input :pid, as: :select, collection: Category.all.map { |c| [c.name, c.id] }, prompt: '-- 选择上级分类 --'
    f.input :opened
    f.input :sort
  end
  f.actions
end

end
