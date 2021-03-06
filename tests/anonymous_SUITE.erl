%%==============================================================================
%% Copyright 2012 Erlang Solutions Ltd.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%% http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%==============================================================================

-module(anonymous_SUITE).
-compile(export_all).

-include_lib("escalus/include/escalus.hrl").
-include_lib("common_test/include/ct.hrl").

%%--------------------------------------------------------------------
%% Suite configuration
%%--------------------------------------------------------------------

all() ->
    [{group, anonymous}].

groups() ->
    [{anonymous, [sequence], all_tests()}].

all_tests() ->
    [messages_story].

suite() ->
    escalus:suite().

%%--------------------------------------------------------------------
%% Init & teardown
%%--------------------------------------------------------------------
init_per_suite(Config) ->
    escalus:init_per_suite(Config).

end_per_suite(Config) ->
    escalus:end_per_suite(Config).

init_per_group(_GroupName, Config) ->
    escalus:create_users(Config, {by_name, [alice, bob]}).

end_per_group(_GroupName, Config) ->
    escalus:delete_users(Config, {by_name, [alice, bob]}).

init_per_testcase(CaseName, Config0) ->
    NewUsers = ct:get_config(escalus_users) ++ ct:get_config(escalus_anon_users),
    Config = [{escalus_users, NewUsers}] ++ Config0,
    escalus:init_per_testcase(CaseName, Config).

end_per_testcase(CaseName, Config) ->
    escalus:end_per_testcase(CaseName, Config).

%%--------------------------------------------------------------------
%% Anonymous tests
%%--------------------------------------------------------------------

messages_story(Config) ->
    escalus:story(Config, [{alice, 1}, {jon, 1}], fun(Alice, Jon) ->
        escalus_client:send(Jon, escalus_stanza:chat_to(Alice, <<"Hi!">>)),
        Stanza = escalus_client:wait_for_stanza(Alice),
        escalus_assert:is_chat_message(<<"Hi!">>, Stanza)
    end).

