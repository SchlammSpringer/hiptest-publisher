require_relative 'spec_helper'
require_relative '../lib/hiptest-publisher/signature_exporter'

describe Hiptest::SignatureExporter do
  include HelperFactories
  let(:exporter) { Hiptest::SignatureExporter.new }

  let(:aw) {
    make_actionword('my action word', [],
      [
        make_parameter('x'),
        make_parameter('y', make_literal(:string, 'Hi, I am a valued parameter'))
      ],
      [],
      '1234-5678'
    )
  }

  let(:aw2) { make_actionword('plic') }

  let(:aws) {
    Hiptest::Nodes::Actionwords.new([aw, aw2])
  }

  let(:project) {
    make_project('My project', [], [], [aw, aw2])
  }

  describe 'self.export_actionwords' do
    it 'exports all actionwords of a project as a hash' do
      expect(Hiptest::SignatureExporter.export_actionwords(project)).to eq([
        {
          "name" => "my action word",
          "uid" => "1234-5678",
          "parameters" => [
            {"name" => "x"},
            {"name" => "y"}
          ]},
        {
          "name" => "plic",
          "uid" => nil,
          "parameters" => []
        }
      ])
    end

    it 'if asked, it also export the AW node' do
      expect(Hiptest::SignatureExporter.export_actionwords(project, true)).to eq([
        {
          "name" => "my action word",
          "uid" => "1234-5678",
          "parameters" => [
            {"name" => "x"},
            {"name" => "y"}
          ],
          "node" => aw},
        {
          "name" => "plic",
          "uid" => nil,
          "parameters" => [],
          "node" => aw2
        }
      ])
    end
  end

  describe 'export_actionwords' do
    it 'exports all actionwords of a project as a hash' do
      expect(exporter.export_actionwords(aws)).to eq([
        {
          "name" => "my action word",
          "uid" => "1234-5678",
          "parameters" => [
            {"name" => "x"},
            {"name" => "y"}
          ]},
        {
          "name" => "plic",
          "uid" => nil,
          "parameters" => []
        }
      ])
    end
  end

  describe 'export_item' do
    it 'exports usefull data an item (scenario, actionword)' do
      expect(exporter.export_item(aw)).to eq({
        "name" => "my action word",
        "parameters" => [{"name"=>"x"}, {"name"=>"y"}],
        "uid" => "1234-5678"
      })
    end
  end

  describe 'export_parameters' do
    it 'exports all parameters of an item as a list' do
      expect(exporter.export_parameters(aw)).to eq([{'name' => 'x'}, {'name' => 'y'}])
    end

    it 'exports an empty list if there is no parameters' do
      expect(exporter.export_parameters(make_actionword('plop'))).to eq([])
    end
  end

  describe 'export_parameter' do
    let(:param) { make_parameter('x', make_literal(:string, 'Hi, I am a valued parameter')) }

    it 'exports the name of a parameter' do
      expect(exporter.export_parameter(param)).to eq({'name' => 'x'})
    end
  end
end