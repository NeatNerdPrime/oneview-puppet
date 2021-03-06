################################################################################
# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
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

Puppet::Type.newtype(:oneview_server_certificate) do
  desc 'Server Certificate'
  # :nocov:
  # Get methods
  ensurable do
    defaultvalues
    newvalue(:retrieve) do
      provider.retrieve
    end
    newvalue(:create_or_update) do
      provider.create_or_update
    end
    newvalue(:get_certificate) do
      provider.get_certificate
    end
    newvalue(:import) do
      provider.import
    end
    newvalue(:remove) do
      provider.remove
    end
    # :nocov:
  end
  newparam(:name, namevar: true) do
    desc 'Server Certificate'
  end
  newproperty(:data) do
    desc 'server certificate data hash containing all specifications'
    validate do |value|
      raise 'Inserted value for data is not valid' unless value.class == Hash
    end
  end
end
