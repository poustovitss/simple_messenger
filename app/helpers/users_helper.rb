module UsersHelper
  def toggle_user_state(user)
    link_to (user.active? ? 'disable' : 'enable').to_s,
            toggle_user_state_user_path(user),
            method: :post,
            data: { confirm: 'Are you sure?' },
            class: toggle_user_button_class(user).to_s

  end

  def delete_user_button(user)
    link_to(user,
            method: :delete,
            data: { confirm: 'Are you sure?' },
            class: "btn btn-xs btn-danger #{disable_button(user)}") do
      '<i class="fa fa-trash" aria-hidden="true"></i>'.html_safe
    end
  end

  def toggle_flash_message(user)
    "User was #{user.active ? 'enabled' : 'disabled'}."
  end

  def toggle_user_button_class(user)
    if user.active?
      "btn btn-xs btn-danger #{disable_button(user)}"
    else
      "btn btn-xs btn-success #{disable_button(user)}"
    end
  end

  def disable_button(user)
    'disabled' if user.current_user?
  end

  def edit_user_button(user)
    link_to(edit_user_path(user),
            class: 'btn btn-xs btn-warning') do
      '<i class="fa fa-pencil" aria-hidden="true"></i>'.html_safe
    end
  end

  def change_user_role_button(user)
    link_to(role_user_path(user),
            class: 'btn btn-xs btn-primary') do
      '<i class="fa fa-lock" aria-hidden="true"></i>'.html_safe
    end
  end
end
