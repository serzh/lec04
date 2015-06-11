%%%-------------------------------------------------------------------
%%% @author serzh
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. Jun 2015 22:12
%%%-------------------------------------------------------------------
-module(cache_server_tests).
-author("serzh").
-include_lib("eunit/include/eunit.hrl").

%% API
-export([]).

read_write_test() ->
  cache_server:start_link([{ttl, 3600}]),

  %% should return saved object
  cache_server:insert(user1, {"Joe", 1988}),
  ?assertEqual({ok, {"Joe", 1988}}, cache_server:lookup(user1)),

  %% should return `notfound` if object not found
  cache_server:remove(user1),
  ?assertEqual({notfound}, cache_server:lookup(user1)),

  catch cache_server:stop().

read_timeout_test() ->
  cache_server:start_link([{ttl, 2}]),

  cache_server:insert(key, value),
  timer:sleep(timer:seconds(3)),
  ?assertEqual({notfound}, cache_server:lookup(key)),

  catch cache_server:stop().

%since_birthday_test() ->
%  users_repository:new(repo2),
%
%  users_repository:put(repo2, {user1, "Joe", 1986}),
%  users_repository:put(repo2, {user2, "Mike", 1987}),
%  users_repository:put(repo2, {user3, "Alex", 1988}),
%
%  ?assert(member({user2, "Mike", 1987}, users_repository:since_birthdate(repo2, 1987))),
%  ?assert(member({user3, "Alex", 1988}, users_repository:since_birthdate(repo2, 1987))),
%
%  users_repository:destroy(repo2).