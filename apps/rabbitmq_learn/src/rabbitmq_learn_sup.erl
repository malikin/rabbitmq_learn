%%%-------------------------------------------------------------------
%% @doc rabbitmq_learn top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(rabbitmq_learn_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

-include_lib("amqp_client/include/amqp_client.hrl").

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    start_rabbit(),
    {ok, { {one_for_all, 0, 1}, []} }.

%%====================================================================
%% Internal functions
%%====================================================================

start_rabbit() ->
    lager:info("Connecting to rabbit", []),

    {ok, Connection} = amqp_connection:start(#amqp_params_network{}),
    {ok, Channel}    = amqp_connection:open_channel(Connection),

    #'queue.declare_ok'{queue = Queue} = amqp_channel:call(Channel, #'queue.declare'{}),

    lager:info("Connected to rabbitmq. Connection: ~p", [Connection]).
