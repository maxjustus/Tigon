### Tigon adds a transform method to Hash, providing a means to rename and merge keys and manipulate their values.

##Installation
    gem install tigon

##Usage
    require 'tigon'

    r = {
      'followers_count' => '310000301',
      'friends_count' => '6',
      'listed_count' => '6',
      'default_profile_image' => false,
      'statuses_count' => '1'
    }.transform(:exclusive => true) do
      morph('followers_count', :friendships) do
        {:followers => value.to_i}
      end

      morph('friends_count', :friendships) do
        {:following => value.to_i}
      end

      morph('listed_count', :listed) do
        value.to_i
      end

      morph('statuses_count', :statuses) do
        value.to_i + 1
      end
    end

    r == {
      :friendships => {
        :followers => 310000301,
        :following => 6
      },
      :listed => 6,
      :statuses => 2
    } # true

##LICENSE

(The MIT License)

Copyright © 2011:

Max Justus Spransy

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
‘Software’), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
