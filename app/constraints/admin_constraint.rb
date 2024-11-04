class AdminConstraint
  def matches?(request)
    return false unless (warden = request.env['warden'])

    warden.user(:admin_user).present?
  end
end
