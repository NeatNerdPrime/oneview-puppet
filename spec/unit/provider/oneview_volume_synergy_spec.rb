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

provider_class = Puppet::Type.type(:oneview_volume).provider(:synergy)
api_version = login[:api_version] || 200
resource_name = 'Volume'
resource_type = Object.const_get("OneviewSDK::API#{api_version}::Synergy::#{resource_name}") unless api_version < 300

describe provider_class, unit: true, if: api_version >= 300 do
  include_context 'shared context'

  let(:resource) do
    Puppet::Type.type(:oneview_volume).new(
      name: 'Storage Pool',
      ensure: 'present',
      data:
          {
            'name' => 'Oneview_Puppet_TEST_VOLUME_1',
            'description' => 'Test',
            'provisioningParameters' => {
              'provisionType' => 'Full',
              'shareable' => true,
              'requestedCapacity' => 1024 * 1024 * 1024,
              'storagePoolUri' => '/rest/'
            },
            'snapshotPoolUri' => '/rest/'
          },
      provider: 'synergy'
    )
  end

  let(:provider) { resource.provider }

  let(:instance) { provider.class.instances.first }

  let(:instance) { provider.class.instances.first }

  context 'given the minimum parameters' do
    before(:each) do
      test = resource_type.new(@client, resource['data'])
      allow(resource_type).to receive(:find_by).with(anything, resource['data']).and_return([test])
      provider.exists?
    end

    it 'should be able to run through self.instances' do
      test = resource_type.new(@client, resource['data'])
      allow(resource_type).to receive(:find_by).with(anything, {}).and_return([test])
      expect(instance).to be
    end

    it 'should be an instance of the provider synergy' do
      expect(provider).to be_an_instance_of Puppet::Type.type(:oneview_volume).provider(:synergy)
    end

    it 'should able to find the resource' do
      expect(provider.found).to be
    end

    it 'runs through the create method' do
      allow(resource_type).to receive(:find_by).and_return([])
      allow_any_instance_of(resource_type).to receive(:create).and_return(resource_type.new(@client, resource['data']))
      provider.exists?
      expect(provider.create).to be
    end

    it 'should be able to get the snapshots' do
      allow_any_instance_of(resource_type).to receive(:get_snapshots).and_return('Test')
      expect(provider.get_snapshot).to be
    end

    it 'should be able to get a snapshot by name' do
      resource['data']['snapshotParameters'] = { 'name' => 'Snapshot' }
      allow_any_instance_of(resource_type).to receive(:get_snapshot).and_return('Test')
      expect(provider.get_snapshot).to be
    end

    it 'should be able to repair' do
      allow_any_instance_of(resource_type).to receive(:repair).and_return('Test')
      expect(provider.repair).to be
    end

    it 'should be able to get the attachable volumes' do
      allow(resource_type).to receive(:get_attachable_volumes).with(anything).and_return('Test')
      expect(provider.get_attachable_volumes).to be
    end

    it 'should be able to get the extra managed volume paths' do
      allow(resource_type).to receive(:get_extra_managed_volume_paths).with(anything).and_return('Test')
      expect(provider.get_extra_managed_volume_paths).to be
    end

    it 'should delete the snapshot' do
      resource['data']['snapshotParameters'] = { 'name' => 'Snapshot' }
      allow_any_instance_of(resource_type).to receive(:delete_snapshot).with(resource['data']['snapshotParameters']['name'])
        .and_return('Test')
      expect(provider.delete_snapshot).to be
    end

    it 'should create the snapshot' do
      resource['data']['snapshotParameters'] = { 'name' => 'Snapshot' }
      allow_any_instance_of(resource_type).to receive(:create_snapshot).with('name' => resource['data']['snapshotParameters']['name'])
        .and_return('Test')
      expect(provider.create_snapshot).to be
    end
  end
end
