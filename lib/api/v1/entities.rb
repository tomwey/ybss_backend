module API
  module V1
    module Entities
      class Base < Grape::Entity
        format_with(:null) { |v| v.blank? ? "" : v }
        format_with(:chinese_date) { |v| v.blank? ? "" : v.strftime('%Y-%m-%d') }
        format_with(:chinese_datetime) { |v| v.blank? ? "" : v.strftime('%Y-%m-%d %H:%M:%S') }
        format_with(:month_date_time) { |v| v.blank? ? "" : v.strftime('%m月%d日 %H:%M') }
        format_with(:money_format) { |v| v.blank? ? 0.00 : ('%.2f' % v) }
        format_with(:rmb_format) { |v| v.blank? ? 0.00 : ('%.2f' % (v / 100.00)) }
        expose :id
        # expose :created_at, format_with: :chinese_datetime
      end # end Base
      
      class UserBase < Base
        expose :uid, as: :id
        expose :private_token, as: :token
      end
      
      # 用户基本信息
      # class UserProfile < UserBase
      #   # expose :uid, format_with: :null
      #   expose :mobile, format_with: :null
      #   expose :nickname do |model, opts|
      #     model.format_nickname
      #   end
      #   expose :avatar do |model, opts|
      #     model.real_avatar_url
      #   end
      #   expose :nb_code, as: :invite_code
      #   expose :earn, format_with: :money_format
      #   expose :balance, format_with: :money_format
      #   expose :today_earn, format_with: :money_format
      #   expose :wx_id, format_with: :null
      #   unexpose :private_token, as: :token
      # end
      
      class AppVersion < Base
        expose :version
        expose :os
        expose :changelog do |model, opts|
          if model.change_log
            arr = model.change_log.split('</p><p>')
            arr.map { |s| s.gsub('</p>', '').gsub('<p>', '') }
          else
            []
          end
        end
        expose :app_url
        expose :must_upgrade
      end
      
      class MediaProvider < Base
        expose :uniq_id, as: :id
        expose :name
        expose :icon do |model, opts|
          model.icon.url(:large)
        end
        expose :url
      end
      
      class MediaHistory < Base
        expose :uniq_id, as: :id
        expose :title, :source_url
        expose :progress, format_with: :null
        expose :created_at, as: :time, format_with: :chinese_datetime
        expose :provider, using: API::V1::Entities::MediaProvider
      end
      
      # 用户资料
      class UserProfile < UserBase
        expose :pid do |model,opts|
          model.profile.try(:id)
        end
        expose :mobile, format_with: :null
        expose :name do |model, opts|
          model.profile.try(:name)
        end
        expose :idcard do |model, opts|
          model.profile.try(:idcard)
        end
        expose :phone do |model, opts|
          model.profile.try(:phone)
        end
        expose :sex do |model, opts|
          model.profile.try(:sex)
        end
        expose :birth do |model, opts|
          model.profile.try(:birth)
        end
        expose :is_student do |model, opts|
          model.profile.try(:is_student)
        end
        expose :college do |model, opts|
          model.profile.try(:college)
        end
        expose :specialty do |model, opts|
          model.profile.try(:specialty)
        end
        expose :current_pay_name, as: :pay_name
        expose :current_pay_account, as: :pay_account
        unexpose :private_token, as: :token
        expose :total_salary_money, as: :total_money, format_with: :money_format
        expose :sent_salary_money, as: :payed_money, format_with: :money_format
        expose :senting_salary_money, as: :unpayed_money, format_with: :money_format
      end
      # 用户详情
      class User < UserBase
        expose :uid, as: :id
        expose :mobile, format_with: :null
        expose :nickname do |model, opts|
          model.format_nickname
        end
        expose :avatar do |model, opts|
          model.format_avatar_url
        end
        expose :balance, format_with: :rmb_format
        expose :vip_expired_at, as: :vip_time, format_with: :chinese_date
        expose :left_days, as: :vip_status
        expose :qrcode_url
        expose :portal_url
        unexpose :private_token, as: :token
        expose :wx_bind
        expose :qq_bind
        
        # expose :vip_expired_at, as: :vip_time, format_with: :chinese_date
        # expose :left_days do |model, opts|
        #   model.left_days
        # end
        # expose :private_token, as: :token, format_with: :null
      end
      
      class SimpleUser < Base
        expose :uid, as: :id
        expose :mobile, format_with: :null
        expose :nickname do |model, opts|
          model.format_nickname
        end
        expose :avatar do |model, opts|
          model.format_avatar_url
        end
      end
      
      class Project < Base
        expose :uniq_id, as: :id
        expose :title
        expose :begin_date, :end_date
        expose :money
        expose :days do |model, opts|
          # (model.begin_date..model.end_date)
          if model.begin_date.blank? or model.end_date.blank? 
            []
          else
            arr = []
            (model.begin_date..model.end_date).each { |d| arr << d }
            arr
          end
        end
      end
      
      class Salary < Base
        expose :uniq_id, as: :id
        expose :project, using: API::V1::Entities::Project
        expose :pay_name, :pay_account
        expose :money, format_with: :money_format
        expose :created_at, as: :time, format_with: :chinese_datetime
        expose :payed_at, as: :pay_time, format_with: :chinese_datetime
        expose :state, :state_name
      end
      
      class SimplePage < Base
        expose :title, :slug
      end
      
      class VipCard < Base
        expose :code
        expose :month
        expose :actived_at, as: :active_time, format_with: :chinese_datetime
      end
      
      class Page < SimplePage
        expose :title, :body
      end
      
      class Attachment < Base
        expose :uniq_id, as: :id
        expose :content_type do |model, opts|
          model.data.content_type
        end
        expose :url do |model, opts|
          model.data.url
        end
        expose :width, :height
      end
      
      # 红包
      class Hongbao < Base
        expose :uniq_id, as: :id
        expose :total_money, format_with: :money_format
        expose :sent_money, format_with: :money_format
        expose :left_money, format_with: :money_format
        expose :min_value, format_with: :money_format
        expose :max_value, format_with: :money_format
      end
      
      class QuizRule < Base
        expose :name do |model, opts|
          '答题抢红包'
        end
        expose :action do |model, opts|
          '提交答案，抢红包'
        end
        expose :question
        expose :answers
      end
      
      class CheckinRule < Base
        expose :name do |model, opts|
          '签到抢红包'
        end
        expose :action do |model, opts|
          '签到抢红包'
        end
        expose :address
        expose :accuracy
        expose :checkined_at, format_with: :chinese_datetime
      end
      
      class Question < Base
        expose :name do |model, opts|
          '答题抢红包'
        end
        expose :action do |model, opts|
          '提交答案，抢红包'
        end
        expose :question
        expose :answers
      end
      
      class Catalog < Base
        expose :uniq_id, as: :id
        expose :name
      end
      
      class RedpackTheme < Base
        expose :uniq_id, as: :id
        expose :name
        expose :icon do |model, opts|
          model.icon.blank? ? '' : model.icon.url(:small)
        end
      end
      
      class RedpackAudio < Base
        expose :uniq_id, as: :id
        expose :name
        expose :file do |model, opts|
          model.file.url
        end
      end
      
      class UserPreviewLog < Base
        expose :uniq_id, as: :id
        expose :theme_url
        expose :audio_url
      end
      
      class SimpleRedpack < Base
        expose :uniq_id, as: :id
        expose :subject
        expose :has_sign do |model, opts|
          model.sign.any?
        end
        expose :is_pin do |model, opts|
          model._type == 0
        end
        expose :is_cash do |model, opts|
          model.use_type == 1
        end
        expose :in_use do |model, opts|
          model.opened
        end
        expose :total_money, format_with: :rmb_format
        expose :total_count
        expose :sent_money, format_with: :rmb_format
        expose :sent_count
        expose :created_at, as: :time, format_with: :month_date_time
      end
      
      class EditableRedpack < SimpleRedpack
        expose :theme, using: API::V1::Entities::RedpackTheme
        expose :audio, as: :audio_obj, using: API::V1::Entities::RedpackAudio
        expose :sign_val do |model, opts|
          model.sign_val
        end
      end
      
      class Redpack < SimpleRedpack
        expose :cover do |model, opts|
          model.redpack_image_url
        end
        expose :audio do |model, opts|
          if model.audio.blank?
            ''
          else
            model.audio.file.url
          end
        end
        expose :detail_url
        # expose :has_sign do |model, opts|
        #   model.sign.any?
        # end
        # expose :is_cash do |model, opts|
        #   model.use_type == 1
        # end
        expose :user, as: :owner, using: API::V1::Entities::User
      end
      
      class RedpackSendLog < Base
        expose :uniq_id, as: :id
        expose :money, format_with: :money_format do |model, opts|
          model.money / 100.0
        end
        expose :is_cash
        expose :qrcode_url
        expose :created_at, as: :time, format_with: :month_date_time
        expose :redpack_owner, as: :hb_owner, using: API::V1::Entities::User, if: proc { |o| o.redpack_owner.present? }
        expose :user, using: API::V1::Entities::User
      end
      
      class SimpleRedpackSendLog < Base
        expose :uniq_id, as: :id
        expose :money, format_with: :money_format do |model, opts|
          model.money / 100.0
        end
        expose :qrcode_url
        expose :created_at, as: :time, format_with: :month_date_time
        expose :redpack, using: API::V1::Entities::SimpleRedpack
        expose :hb_sender, using: API::V1::Entities::User do |model, opts|
          model.redpack.try(:user)
        end
      end
      
      class RedpackConsume < Base
        expose :uniq_id, as: :id
        expose :money, format_with: :rmb_format
        expose :user, using: API::V1::Entities::SimpleUser do |model, opts|
          model.user_for_action(opts[:opts][:action])
        end
        expose :created_at, as: :time, format_with: :month_date_time
      end
      
      class SignRule < Base
        expose :name do |model, opts|
          '口令红包'
        end
        expose :action do |model, opts|
          '提交口令，抢红包'
        end
        expose :answer_from_tip, as: :grab_tip
      end
      
      class SharePoster < Base
        expose :name do |model, opts|
          '分享红包'
        end
        expose :action do |model, opts|
          '提交分享，抢红包'
        end
        expose :grab_tip do |model, opts|
          '长按下图发送给朋友或保存到手机发朋友圈，好友识别二维码抢红包，您得分享红包。'
        end
        # expose :share_image
        # expose :answer_fsrom_tip, as: :grab_tip
      end
      
      class LocationCheckin < Base
        expose :name do |model, opts|
          '签到抢红包'
        end
        expose :action do |model, opts|
          '签到抢红包'
        end
        expose :address
        expose :accuracy
      end
      
      class EventOwner < Base
        expose :id do |model, opts|
          model.try(:uid) || model.id
        end
        expose :type do |model, opts|
          if model.class.to_s == 'Admin'
            ''
          else
            model.class.to_s
          end
        end
        expose :nickname do |model, opts|
          if model.class.to_s == 'Admin'
            '系统'
          elsif model.class.to_s == 'User'
            model.try(:format_nickname) || ''
          else 
            '未知'
          end
        end
        expose :avatar do |model, opts|
          if model.class.to_s == 'Admin'
            ''
          elsif model.class.to_s == 'User'
            model.real_avatar_url
          else 
            ''
          end
        end
      end
      
      class RedbagOwner < Base
        expose :id do |model, opts|
          model.try(:uid) || model.id
        end
        expose :type do |model, opts|
          if model.class.to_s == 'Admin'
            ''
          else
            model.class.to_s
          end
        end
        expose :nickname do |model, opts|
          model.try(:format_nickname) || '未知'
        end
        expose :avatar do |model, opts|
          if model.class.to_s == 'Admin'
            CommonConfig.offical_app_icon || ''
          elsif model.class.to_s == 'User'
            model.real_avatar_url
          else 
            ''
          end
        end
      end
      
      class SimpleRedbag < Base
         expose :uniq_id, as: :id
         expose :total_money, format_with: :money_format
         expose :sent_money, format_with: :money_format
         expose :left_money, format_with: :money_format
         expose :min_value, format_with: :money_format
         expose :max_value, format_with: :money_format
      end
      
      class Redbag < Base
        expose :uniq_id, as: :id
        expose :title
        expose :use_type
        expose :image do |model, opts|
          model.icon_image
        end
        expose :cover_image do |model, opts|
          model.cover_image
        end
        expose :ownerable, as: :owner, using: API::V1::Entities::RedbagOwner, if: proc { |e| e.ownerable.present? }
        expose :rule_type do |model, opts| 
          if model.ruleable_type == 'Question'
            'quiz'
          elsif model.ruleable_type == 'LocationCheckin'
            'checkin'
          elsif model.ruleable_type == 'SignRule'
            'sign'
          elsif model.ruleable_type == 'SharePoster'
            'poster'
          else
            ''
          end
        end
        expose :grab_time do |model, opts|
          if model.started_at.blank?
            ""
          else
            model.started_at.strftime('%Y-%m-%d %H:%M')
          end
        end
        expose :grabed do |model, opts|
          model.grabed_with_opts(opts)
        end
        expose :distance do |model, opts|
          model.try(:distance) || ''
        end
        expose :lat do |model, opts|
          model.location ? model.location.y : 0
        end
        expose :lng do |model, opts|
          model.location ? model.location.x : 0
        end
        expose :type do |model, opts|
          model._type
        end
        expose :has_shb do |model, opts|
          model.share_hb_id.present?
        end
        expose :opened
        expose :view_count, :share_count, :likes_count
        expose :sent_count do |model, opts|
          model.total_sent_count
        end
        expose :total_money, format_with: :money_format
        expose :sent_money, format_with: :money_format
        expose :left_money, format_with: :money_format
        expose :min_value, format_with: :money_format
        expose :max_value, format_with: :money_format
        expose :created_at, as: :time, format_with: :chinese_datetime
        expose :state_name do |model, opts|
          model.opened ? '已上架' : '未上架'
        end
        expose :state do |model, opts|
          model.opened ? 1 : 0
        end
      end
      
      class MyRedbag < Redbag
        expose :share_hb, as: :shb, using: API::V1::Entities::SimpleRedbag, if: proc { |hb| hb.share_hb.present? }
      end
      
      # 红包详情
      class RedbagDetail < Redbag
        unexpose :distance
        expose :disable_text do |model, opts|
          model.disable_text_with_opts(opts)
        end
        # expose :view_count, :share_count, :likes_count, :sent_hb_count
        expose :body do |model, opts|
          if model.hbable
            model.hbable.try(:body) || ''
          else
            ''
          end
        end
        # expose :body_url, format_with: :null
        expose :rule, if: proc { |e| e.ruleable.present? } do |model, opts|
          if model.ruleable_type == 'Question'
            API::V1::Entities::Question.represent model.ruleable
          elsif model.ruleable_type == 'LocationCheckin'
            API::V1::Entities::LocationCheckin.represent model.ruleable
          elsif model.ruleable_type == 'SignRule'
            API::V1::Entities::SignRule.represent model.ruleable
          elsif model.ruleable_type == 'SharePoster'
            API::V1::Entities::SharePoster.represent model.ruleable
          else
            {}
          end
        end
        
        expose :share_poster_url, if: proc { |e| e.ruleable_type == 'SharePoster' } do |model, opts|
          model.share_poster_image(opts)
        end
        
      end
      
      class Card < Base
        expose :uniq_id, as: :id
        expose :title
        expose :image do |model, opts|
          model.image.blank? ? '' : model.image.url(:large)
        end
        expose :view_count, :share_count, :use_count, :sent_count, :quantity
        expose :body
        expose :created_at, as: :time, format_with: :chinese_datetime
        expose :expire_desc do |model, opts|
          '自领取之日起30天内有效'
        end
      end
      
      class UserCard < Base
        expose :uniq_id, as: :id
        expose :title
        expose :image do |model, opts|
          model.image.blank? ? '' : model.image.url(:large)
        end
        expose :body_url
        expose :expired_at, as: :expire_time, format_with: :chinese_date
        expose :get_time, format_with: :chinese_datetime
        expose :created_at, as: :time, format_with: :chinese_datetime
      end
      
      class SimpleUserCard < Base
        expose :uniq_id, as: :id
        expose :title
        expose :get_time, format_with: :chinese_datetime
        expose :used_at, as: :use_time, format_with: :chinese_datetime
        expose :user, using: API::V1::Entities::SimpleUser
      end
      
      class RedbagEarnLog < Base
        expose :uniq_id, as: :id
        expose :money, format_with: :money_format
        expose :user, using: API::V1::Entities::UserProfile
        expose :redbag, as: :hb, using: API::V1::Entities::Redbag
        expose :user_card, as: :card, using: API::V1::Entities::UserCard, if: proc { |e| e.user_card.present? }
        expose :created_at, as: :time, format_with: :chinese_datetime
      end
      
      # 抽奖
      class LuckyDraw < Base
        expose :uniq_id, as: :id
        expose :title
        expose :image do |model, opts|
          model.image.blank? ? '' : model.image.url(:large)
        end
        expose :view_count, :share_count, :draw_count
        expose :user_prized_count do |model, opts|
          model.user_prized_count(opts)
        end
      end
      
      class LuckyDrawDetail < LuckyDraw
        expose :ownerable, as: :owner, using: API::V1::Entities::RedbagOwner, if: proc { |e| e.ownerable.present? }
        expose :plate_image do |model, opts|
          model.plate_image.url
        end
        expose :prize_desc, format_with: :null
        expose :arrow_image do |model, opts|
          model.real_arrow_image_url
        end
        expose :bg_image do |model, opts|
          model.real_background_image_url
        end
      end
      
      class LuckyDrawItem < Base
        expose :uniq_id, as: :id
        expose :name, :angle
        expose :count do |model, opts|
          (model.quantity || 0).to_i
        end
        expose :sent_count
        expose :is_virtual_goods, as: :is_vg
        expose :description, as: :desc
      end
      
      class LuckyDrawPrizeLog < Base
        expose :uniq_id, as: :id
        expose :prize, using: API::V1::Entities::LuckyDrawItem
        expose :user, using: API::V1::Entities::UserProfile
        expose :lucky_draw, as: :prize_event, using: API::V1::Entities::LuckyDraw
        expose :created_at, as: :time, format_with: :chinese_datetime
      end
      
      # 积分墙渠道
      class OfferwallChannel < Base
        expose :uniq_id, as: :id
        expose :name
        expose :icon do |model, opts|
          model.icon.blank? ? '' : model.icon.url(:big)
        end
        expose :earn_desc do |model, opts|
          '100积分=1元'
        end
        expose :task_url do |model, opts|
          if opts && opts[:opts]
            user = opts[:opts][:user]
            "#{model.task_url}#{Offerwall.send(model.req_sig_method.to_sym, model, user.wechat_profile.openid)}"
          else
            model.task_url
          end
        end
      end
      
      # 活动
      class Event < Base
        expose :uniq_id, as: :id
        expose :title
        expose :image do |model, opts|
          model.image.url(:small)
        end
        expose :ownerable, as: :owner, using: API::V1::Entities::EventOwner, if: proc { |e| e.ownerable.present? }
        expose :current_hb, as: :hb, using: API::V1::Entities::Hongbao, if: proc { |e| e.current_hb.present? }
        expose :share_hb, using: API::V1::Entities::Hongbao, if: proc { |e| e.share_hb_id.present? }
        expose :lat do |model, opts|
          model.location ? model.location.y : 0
        end
        expose :lng do |model, opts|
          model.location ? model.location.x : 0
        end
        expose :distance do |model, opts|
          model.try(:distance) || ''
        end
        expose :rule_type do |model, opts|
          model.ruleable_type
        end
        expose :grab_time do |model, opts|
          if model.started_at.blank?
            ""
          else
            model.started_at.strftime('%Y-%m-%d %H:%M')
          end
        end
        expose :grabed do |model, opts|
          model.grabed_with_opts(opts)
        end
        expose :state
        expose :state_name
        expose :view_count, :share_count, :likes_count, :sent_hb_count
        expose :created_at, as: :time, format_with: :chinese_datetime
      end
      
      class EventEarnLog < Base
        expose :uniq_id, as: :id
        expose :money, format_with: :money_format
        expose :user, using: API::V1::Entities::UserProfile
        expose :event, using: API::V1::Entities::Event
        expose :created_at, as: :time, format_with: :chinese_datetime
      end
      
      class TradeLog < Base
        expose :uniq_id, as: :id, format_with: :null
        expose :title
        expose :money, format_with: :rmb_format
        expose :created_at, as: :time, format_with: :month_date_time
      end
      
      # 活动详情
      # class EventDetail < Event
      #   unexpose :distance
      #   expose :image do |model, opts|
      #     model.image.url(:large)
      #   end
      #   expose :disable_text do |model, opts|
      #     model.disable_text_with_opts(opts)
      #   end
      #   expose :view_count, :share_count, :likes_count, :sent_hb_count
      #   expose :body, format_with: :null
      #   expose :body_url, format_with: :null
      #   expose :rule, if: proc { |e| e.ruleable.present? } do |model, opts|
      #     if model.ruleable_type == 'QuizRule'
      #       API::V1::Entities::QuizRule.represent model.ruleable
      #     elsif model.ruleable_type == 'CheckinRule'
      #       API::V1::Entities::CheckinRule.represent model.ruleable
      #     else
      #       {}
      #     end
      #   end
      #   expose :latest_earns do |model, opts|
      #     if model.latest_earns.empty?
      #       []
      #     else
      #       API::V1::Entities::EventEarnLog.represent model.latest_earns
      #     end
      #   end
      # end
      
      class Banner < Base
        expose :uniq_id, as: :id
        expose :image do |model, opts|
          model.image.url(:large)
        end
        expose :link, format_with: :null
        
        expose :view_count, :click_count
      end
      
      # 供应商
      class Merchant < Base
        expose :merch_id, as: :id
        expose :name
        expose :avatar do |model, opts|
          model.avatar.blank? ? '' : model.avatar.url(:large)
        end
        expose :mobile
        expose :follows_count
        expose :address, format_with: :null
        expose :type do |model, opts|
          model.auth_type.blank? ? '' : model.auth_type
        end
        # expose :note, format_with: :null
      end
      
      # 收益明细
      class EarnLog < Base
        expose :title
        expose :earn
        expose :unit
        expose :created_at, as: :time, format_with: :chinese_datetime
      end
      
      # 消息
      class Message < Base
        expose :title do |model, opts|
          model.title || '系统公告'
        end#, format_with: :null
        expose :content, as: :body
        expose :created_at, format_with: :chinese_datetime
      end
      
      class Author < Base
        expose :nickname do |model, opts|
          model.nickname || model.mobile
        end
        expose :avatar do |model, opts|
          model.avatar.blank? ? "" : model.avatar_url(:large)
        end
      end
      
      # 提现
      class Withdraw < Base
        expose :bean, :fee
        expose :total_beans do |model, opts|
          model.bean + model.fee
        end
        expose :pay_type do |model, opts|
          if model.account_type == 1
            "微信提现"
          elsif model.account_type == 2
            "支付宝提现"
          else
            ""
          end
        end
        expose :state_info, as: :state
        expose :created_at, as: :time, format_with: :chinese_datetime
        expose :user, using: API::V1::Entities::Author
      end
      
    end
  end
end