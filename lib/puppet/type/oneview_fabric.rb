################################################################################
# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
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

require_relative 'common'

Puppet::Type.newtype(:oneview_fabric) do
  desc "Oneview's Fabric"

  ensurable do
    defaultvalues

    # :nocov:
    newvalue(:found) do
      provider.found
    end

    newvalue(:get_fabrics) do
      provider.get_fabrics
    end

    newvalue(:get_schema) do
      provider.get_schema
    end

    newvalue(:get_reserved_vlan_range) do
      provider.get_reserved_vlan_range
    end
    # :nocov:
  end

  newparam(:name, namevar: true) do
    desc 'Fabric name'
  end

  newparam(:data) do
    desc 'Fabric data hash containing all specifications for the system'
    validate do |value|
      unless value.class == Hash
        fail Puppet::Error, 'Inserted value for data is not valid'
      end
      uri_validation(value)
    end
  end
end
