require 'rest-client'
module API
  module V1
    class YbssAPI < Grape::API
      
      helpers API::SharedParams
      
      resource :user, desc: "用户账号相关" do
        desc "用户登录"
        params do
          requires :login, type: String, desc: "手机或昵称"
          requires :password, type: String, desc: "密码"
        end
        post :login do
          user = User.where("mobile = :login or nickname = :login", { login: params[:login].downcase }).first
          if user.blank?
            return { code: -2, message: "账号不存在" }
          end
          
          if !user.authenticate(params[:password])
            return { code: -1, message: "密码不正确" }
          end
          
          { token: user.private_token }
        end
        
        desc "获取账号个人资料"
        params do
          requires :token, type: String, desc: "登录TOKEN"
        end
        get :me do
          user = authenticate!
          render_json(user, API::V1::Entities::User)
        end
      end # end user resource
      
      resource :ybss do
        desc "扫码查询"
        params do
          requires :token,   type: String, desc: "登录TOKEN"
          requires :addr_id, type: String, desc: "地址ID"
        end
        get :house do
          user = authenticate!
          
          address = Address.find_by(addr_id: params[:addr_id])
          if address.blank?
            return render_error(4004, "不存在的地址")
          end
          
          if address.house.blank?
            return render_error(4001, "该地址还未绑定房屋")
          end
          
          OperateLog.create!(house_id: address.house.id, title: "扫码查询地址", action: "扫码查询地址", operateable: address.house, begin_time: Time.zone.now, owner_id: user.id)
          
          render_json(address.house, API::V1::Entities::House)
        end # end get house
        
        
      end # end resource
      
    end
  end
end