##
# @api REST
# Describes a User
#
# Example:
#   ```
#   <user>
#     <login>admin</login>
#     <consumed-gears>4</consumed-gears>
#     <max-gears>100</max-gears>
#     <capabilities>
#       <subaccounts>false</subaccounts>
#       <gear-sizes>
#         <gear-size>small</gear-size>
#       </gear-sizes>
#     </capabilities>
#     <plan-id nil="true"/>
#     <usage-account-id nil="true"/>
#     <links>
#     ...
#     </links>
#   </user>
#   ```
#
# @!attribute [r] login
#   @return [String] The login name of the user
# @!attribute [r] consumed_gears
#   @return [Integer] Number of gears currently being used in applications
# @!attribute [r] max_gears
#   @return [Integer] Maximum number of gears avaiable to the user
# @!attribute [r] capabilities
#   @return [Hash] Map of user capabilities
# @!attribute [r] plan_id
#   @return [String] Plan ID
# @!attribute [r] usage_account_id
#   @return [String] Account ID
class RestUser < OpenShift::Model
  attr_accessor :id, :login, :consumed_gears, :capabilities, :plan_id, :usage_account_id, :links, :max_gears, :created_at

  def initialize(cloud_user, url, nolinks=false)
    [:id, :login, :consumed_gears, :plan_id, :usage_account_id, :created_at].each{ |sym| self.send("#{sym}=", cloud_user.send(sym)) }

    self.capabilities = cloud_user.get_capabilities
    self.max_gears = capabilities["max_gears"]
    self.capabilities.delete("max_gears")

    unless nolinks
      @links = {
        "LIST_KEYS" => Link.new("Get SSH keys", "GET", URI::join(url, "user/keys")),
        "ADD_KEY" => Link.new("Add new SSH key", "POST", URI::join(url, "user/keys"), [
          Param.new("name", "string", "Name of the key"),
          Param.new("type", "string", "Type of Key", SshKey.get_valid_ssh_key_types()),
          Param.new("content", "string", "The key portion of an rsa key (excluding ssh-rsa and comment)"),
        ]),
      }
      @links["DELETE_USER"] = Link.new("Delete user. Only applicable for subaccount users.", "DELETE", URI::join(url, "user"), nil, [
        OptionalParam.new("force", "boolean", "Force delete user. i.e. delete any domains and applications under this user", [true, false], false)
      ]) if cloud_user.parent_user_id
    end
  end

  def to_xml(options={})
    options[:tag_name] = "user"
    super(options)
  end
end
