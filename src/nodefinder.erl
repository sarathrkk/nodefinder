%-*-Mode:erlang;coding:utf-8;tab-width:4;c-basic-offset:4;indent-tabs-mode:()-*-
% ex: set ft=erlang fenc=utf-8 sts=4 ts=4 sw=4 et:

-module(nodefinder).

%% external interface
-export([multicast_start/0,
         multicast_start/4,
         multicast_discover/1,
         multicast_stop/0]).

-spec multicast_start() ->
    {ok, pid()} |
    {error, any()}.

multicast_start() ->
    multicast_start({224,0,0,1}, 4475, 1, 300).

-spec multicast_start(Addr :: inet:ip_address(),
                      Port :: inet:port_number(),
                      TTL :: non_neg_integer(),
                      TimeoutSeconds :: pos_integer()) ->
    {ok, pid()} |
    {error, any()}.

multicast_start(Addr, Port, TTL, TimeoutSeconds)
    when is_integer(Port), Port > 0,
         is_integer(TTL), TTL >= 0,
         is_integer(TimeoutSeconds), TimeoutSeconds > 0 ->
    nodefinder_sup:start_child(nodefinder_multicast,
                               [Addr, Port, TTL, TimeoutSeconds]).

-spec multicast_discover(Timeout :: pos_integer()) ->
    ok |
    {error, any()}.

multicast_discover(Timeout)
    when is_integer(Timeout), Timeout > 0 ->
    nodefinder_multicast:discover(Timeout).

-spec multicast_stop() ->
    ok |
    {error, any()}.

multicast_stop() ->
    nodefinder_sup:stop_child(nodefinder_multicast).

