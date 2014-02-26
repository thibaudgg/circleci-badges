require 'sinatra'
require 'open-uri'
require 'multi_xml'

class CircleCI
  attr_accessor :owner, :repo, :token

  def initialize(owner, repo, token)
    @owner = owner
    @repo = repo
    @token = token
  end

  def status
    xml = open(_url).read
    data = MultiXml.parse(xml)
    p data
    data['Projects']['Project']['lastBuildStatus']
  end

  private

  def _url
    "https://circleci.com/gh/#{owner}/#{repo}.cc.xml?circle-token=#{token}"
  end

end

get '/:owner/:repo/:token' do
  circleci = CircleCI.new(params[:owner], params[:repo], params[:token])
  if circleci.status == 'Success'
    redirect 'https://img.shields.io/badge/build-passing-green.svg'
  else
    redirect 'https://img.shields.io/badge/build-failing-red.svg'
  end
end
