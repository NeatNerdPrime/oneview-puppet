################################################################################
# (C) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

require_relative '../oneview_resource'

Puppet::Type.type(:oneview_unmanaged_device).provide :c7000, parent: Puppet::OneviewResource do
  desc 'Provider for OneView Unmanaged Devices using the C7000 variant of the OneView API'

  confine feature: :oneview
  confine true: login[:hardware_variant] == 'C7000'

  mk_resource_methods

  def exists?
    super([nil, :found, :absent])
  end

  def create
    super(:add)
  end

  def destroy
    ud = @resource_type.find_by(@client, @data)
    raise('There were no matching Unmanaged Devices in the Appliance.') if ud.empty?
    ud.map(&:remove)
  end

  def get_environmental_configuration
    Puppet.notice("\n\nUnmanaged Device Environmental Configuration\n")
    pretty get_single_resource_instance.environmental_configuration
    true
  end
end
