require 'spec_helper'

describe 'Hash' do
  context 'transform' do
    it 'takes a block in which you call morph - passing in the name of the key to morph, the new name, and an optional block to further transform the value(s)' do
      h = {
        'guy' => 'guy',
        'cool' => {'stuff' => 'neat'},
        'otherthing' => 'rad411'
      }

      h.transform do
        morph('cool', :cool) do
          morph('stuff', :stuff) {value.upcase}
        end 
        morph('otherthing', :thing) {value.gsub('rad','')}
      end.should == {
        'guy' => 'guy',
        :cool => {:stuff => 'NEAT'},
        :thing => '411'
      }
    end

    it 'allows you to call morph without passing a block' do
      h = {
        'guy' => 'guy',
        'cool' => {'stuff' => 'neat'},
        'otherthing' => 'rad411'
      }

      h.transform do
        morph('cool', :cool)
      end.should == {
        'guy' => 'guy',
        :cool => {'stuff' => 'neat'},
        'otherthing' => 'rad411'
      }
    end

    it 'ignores transformations which are not present in source hash' do
      h = {
        'guy' => 'guy',
        'cool' => {'stuff' => 'neat'},
        'otherthing' => 'rad411'
      }

      h.transform do
        morph(['cool', 'thing'], :cool)
        morph('rawr', :cool)
        morph('cool', :cool)
      end.should == {
        'guy' => 'guy',
        :cool => {'stuff' => 'neat'},
        'otherthing' => 'rad411'
      }
    end

    it 'allows you to call morph with the name of the current key and a block' do
      h = {
        'guy' => 'guy',
        'cool' => {'stuff' => 'neat'},
        'otherthing' => 'rad411'
      }
      h.transform do
        morph('cool') do
          morph('stuff') do
            value.upcase
          end
        end
      end.should == {
        'guy' => 'guy',
        'cool' => {'stuff' => 'NEAT'},
        'otherthing' => 'rad411'
      }
    end

    it 'allows you to morph two different keys into the same key' do
      h = {
        'guy' => 'guy',
        'cool' => {'stuff' => 'neat'},
        'otherthing' => 'rad411'
      }

      h.transform(:exclusive => true) do
        morph('guy', 'neat') do
          {'man' => value}
        end
        morph('cool', 'neat') do
          morph('stuff') do
            value.upcase
          end
        end
      end.should == {
        'neat' => {
          'man' => 'guy',
          'stuff' => 'NEAT'
        }
      }
    end

    it 'allows you to pass an array to morph subhashes of the value of the key' do
      h = {
        'guy' => {'man' => 'bro'},
        'cool' => {
          'stuff' => 'neat',
          'run' => 'fast'
        },
        'otherthing' => {
          'rad411' => {'cool' => 'neat'}
        },
        'tools' => {
          'hammer' => {
            'rock' => {'stove' => 'iron'}
          }
        }
      }

      h.transform(:exclusive => true) do
        morph(['cool', 'stuff'], 'neat') do
          {'important' => value.upcase}
        end

        morph(['cool', 'run'], 'neat') do
          {'run' => value}
        end

        morph(['otherthing', 'rad411', 'cool'], 'neat') do
          {'critical' => value.upcase + 's'}
        end

        morph(['guy', 'man'], 'kewl') do
          value.upcase
        end

        morph(['tools', 'hammer'], 'toolz')
      end.should == {
        'kewl' => 'BRO',
        'neat' => {
          'important' => 'NEAT',
          'critical' => 'NEATs',
          'run' => 'fast'
        },
        'toolz' => {
          'rock' => {'stove' => 'iron'}
        }
      }
    end

    it 'allows you to call keep to keep a key if :exclusive is set to true' do
      h = {
        'guy' => 'guy',
        'cool' => {'stuff' => 'neat'},
        'otherthing' => 'rad411'
      }

      h.transform(:exclusive => true) do
        morph('cool') do
          morph('stuff') do
            value.upcase
          end
        end
        keep('guy')
      end.should == {'guy' => 'guy', 'cool' => {'stuff' => 'NEAT'}}
    end

    it 'has an :exclusive option which restricts the returned hash to values passed to morph within block' do
      h = {
        'guy' => 'guy',
        'cool' => {
          'stuff' => 'neat',
          'otherthing' => 'cool',
          'thingthing' => {
            't' => 't',
            'thing' => 'thing'
          }
        },
        'otherthing' => 'rad411'
      }

      h.transform(:exclusive => true) do
        morph('cool', :cool) do
          morph('stuff', :stuff) {value.upcase}
          morph('thingthing', :thing, :exclusive => false) do
            morph('thing') do
              value.reverse
            end
          end
        end 
        morph('otherthing', :thing) {value.gsub('rad','')}
      end.should == {
        :cool => {
          :stuff => 'NEAT',
          :thing => {
            'thing' => 'gniht',
            't' => 't'
          }
        },
        :thing => '411'
      }
    end
  end
end
