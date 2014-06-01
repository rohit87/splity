class UserProfilePresenter

  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  VisibleAttributes = [:id, :email, :name].freeze
  EditableAttributes = [:email, :name].freeze

  delegate :id, :email, :name, :created_at, to: :user

  def initialize(user)
    @user = user
  end

  def member_since
    since = (Time.zone.now - user.created_at).to_i / 1.day
    "#{pluralize(since, "day")}"
  end

  def get_field(field, is_correct_user)
    return readonly_field(field) if !is_correct_user
    if editable_field?(field) then return editable_field(field) else return readonly_field(field) end
  end

  def editable_field(field)
    link_to user[field], "javascript:void(0)", {
      :class => "xeditable",
      id: "editable#{field}",
      data: {
        fieldname: field.to_s
      }
    }
  end

  def readonly_field(field)
    user[field]
  end

  def patch_user_path
    user_patch_user_path self.id
  end

  private
    attr_reader :user

    def editable_field?(field)
      field = field.to_s unless field.is_a?(Symbol)
      UserProfilePresenter::EditableAttributes.include?(field)
    end
end