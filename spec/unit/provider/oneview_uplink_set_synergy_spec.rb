################################################################################
# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
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

require 'spec_helper'
require_relative '../../support/fake_response'
require_relative '../../shared_context'

provider_class = Puppet::Type.type(:oneview_uplink_set).provider(:synergy)
api_version = login[:api_version] || 200
resource_name = 'UplinkSet'
resource_type = Object.const_get("OneviewSDK::API#{api_version}::Synergy::#{resource_name}") unless api_version < 300

describe provider_class, unit: true, if: api_version >= 300 do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_uplink_set).new(
      name: 'uplink_set_1',
      ensure: 'found',
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  context 'given the Creation parameters' do
    let(:resource) do
      Puppet::Type.type(:oneview_uplink_set).new(
        name: 'uplink_set_1',
        ensure: 'present',
        data:
            {
              'nativeNetworkUri'               => 'nil',
              'reachability'                   => 'Reachable',
              'manualLoginRedistributionState' => 'NotSupported',
              'connectionMode'                 => 'Auto',
              'lacpTimer'                      => 'Short',
              'networkType'                    => 'Ethernet',
              'ethernetNetworkType'            => 'Tagged',
              'description'                    => 'nil',
              'name'                           => 'Puppet Uplink Set',
              'portConfigInfos' =>
              [
                '/rest/interconnects/8e48bbd0-b651-46e1-afdf-334332a3a233',
                'Auto',
                [{ value: 1, type: 'Bay' }, { value: '/rest/enclosures/09SGH100X6J1', type: 'Enclosure' }, { value: 'X1', type: 'Port' }]
              ],
              'networkUris' => [
                '/rest/fake/1', '/rest/fake/2'
              ],
              'logicalInterconnectUri' => '/rest/fake/3'
            },
        provider: 'synergy'
      )
    end

    it 'should be an instance of the provider synergy of oneview_uplink_set' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_uplink_set).provider(:synergy)
    end

    it 'should return false if resource does not exist' do
      allow(resource_type).to receive(:find_by).and_return([])
      expect(provider.exists?).to eq(false)
      expect { provider.found }.to raise_error(/No UplinkSet with the specified data were found on the Oneview Appliance/)
    end

    it 'should return true if resource exists / is found' do
      test = OneviewSDK::UplinkSet.new(@client, resource['data'])
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      expect(provider.exists?).to be
      expect(provider.found).to eq(true)
    end

    it 'deletes the resource' do
      resource['data']['uri'] = '/rest/fake'
      test = OneviewSDK::UplinkSet.new(@client, resource['data'])
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      allow(resource_type).to receive(:find_by).with(anything, name: resource['data']['name']).and_return([test])
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_delete).and_return(FakeResponse.new('uri' => '/rest/fake'))
      provider.exists?
      expect(provider.destroy).to be
    end
  end

  context 'When using FC Network ' do
    let(:resource) do
      Puppet::Type.type(:oneview_uplink_set).new(
        name: 'uplink_set_1',
        ensure: 'present',
        data:
            {
              'nativeNetworkUri'               => 'nil',
              'reachability'                   => 'Reachable',
              'manualLoginRedistributionState' => 'NotSupported',
              'connectionMode'                 => 'Auto',
              'lacpTimer'                      => 'Short',
              'networkType'                    => 'Ethernet',
              'ethernetNetworkType'            => 'Tagged',
              'description'                    => 'nil',
              'name'                           => 'Puppet Uplink Set',
              'portConfigInfos' =>
              [
                '/rest/interconnects/8e48bbd0-b651-46e1-afdf-334332a3a233',
                'Auto',
                [{ value: 1, type: 'Bay' }, { value: '/rest/enclosures/09SGH100X6J1', type: 'Enclosure' }, { value: 'X1', type: 'Port' }]
              ],
              'fcNetworkUris' => [
                '/rest/fake/1', '/rest/fake/2'
              ],
              'logicalInterconnectUri' => '/rest/fake/3'
            },
        provider: 'synergy'
      )
    end

    it 'runs through the create method' do
      allow(resource_type).to receive(:find_by).and_return([])
      fc_network = OneviewSDK::FCNetwork.new(@client, name: 'Puppet Test FCNetwork', uri: '/rest/fc-networks/fake')
      logint = OneviewSDK::LogicalInterconnect.new(@client, name: 'Encl1-Test Oneview', uri: '/rest/logical-interconnects/fake')
      allow(OneviewSDK::FCNetwork).to receive(:find_by).and_return([fc_network])
      allow(OneviewSDK::LogicalInterconnect).to receive(:find_by).and_return([logint])
      allow_any_instance_of(resource_type).to receive(:create).and_return(OneviewSDK::UplinkSet.new(@client, resource['data']))
      provider.exists?
      expect(provider.create).to eq(true)
    end
  end

  context 'When using FCoE Network ' do
    let(:resource) do
      Puppet::Type.type(:oneview_uplink_set).new(
        name: 'uplink_set_1',
        ensure: 'present',
        data:
            {
              'nativeNetworkUri'               => 'nil',
              'reachability'                   => 'Reachable',
              'manualLoginRedistributionState' => 'NotSupported',
              'connectionMode'                 => 'Auto',
              'lacpTimer'                      => 'Short',
              'networkType'                    => 'Ethernet',
              'ethernetNetworkType'            => 'Tagged',
              'description'                    => 'nil',
              'name'                           => 'Puppet Uplink Set',
              'portConfigInfos' =>
              [
                '/rest/interconnects/8e48bbd0-b651-46e1-afdf-334332a3a233',
                'Auto',
                [{ value: 1, type: 'Bay' }, { value: '/rest/enclosures/09SGH100X6J1', type: 'Enclosure' }, { value: 'X1', type: 'Port' }]
              ],
              'fcoeNetworkUris' => [
                '/rest/fake/1', '/rest/fake/2'
              ],
              'logicalInterconnectUri' => '/rest/fake/3'
            },
        provider: 'synergy'
      )
    end

    it 'runs through the create method' do
      allow(resource_type).to receive(:find_by).and_return([])
      fcoe_network = OneviewSDK::FCoENetwork.new(@client, name: 'Puppet Test FCoENetwork', uri: '/rest/fcoe-networks/fake')
      logint = OneviewSDK::LogicalInterconnect.new(@client, name: 'Encl1-Test Oneview', uri: '/rest/logical-interconnects/fake')
      allow(OneviewSDK::FCoENetwork).to receive(:find_by).and_return([fcoe_network])
      allow(OneviewSDK::LogicalInterconnect).to receive(:find_by).and_return([logint])
      allow_any_instance_of(resource_type).to receive(:create).and_return(OneviewSDK::UplinkSet.new(@client, resource['data']))
      provider.exists?
      expect(provider.create).to eq(true)
    end
  end
end
