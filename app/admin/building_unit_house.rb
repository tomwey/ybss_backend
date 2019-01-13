ActiveAdmin.register BuildingUnitHouse do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :address_id, :building_id, :unit_id, :house_id
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
    f.input :address_id, label: "所在地址", collection: Address.valid_addresses.map { |a| [a.name, a.id] }
    f.input :building_id, label: "所属楼栋", collection: Building.order('id asc').map { |b| [b.name, b.id] }
    f.input :unit_id, label: "所属单元", collection: Unit.order('id asc').map { |b| [b.name, b.id] }
    f.input :house_id, as: :select, label: "关联房屋", collection: House.valid_houses.map { |h| [h.id, h.id] }
  end
  f.actions
end

end
