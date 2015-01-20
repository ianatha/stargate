# Stargate

Stargate bridges the gap between web-based interactive APIs and the console.

You run `stargate` by specifiying the initial URL of the interaction like so: 

```sh
stargate https://oauth.provider.com/authorize?client_id=FOO
```

Stargate terminates when the user is redirected to a URL that starts with `stargate-result://`, or when the user manually closes stargate. In the latter case, the exit code is non-zero.

```sh
$ stargate https://oauth.provider.com/authorize?client_id=FOO
... user interacts with the browser ...
stargate-result://result?code=0819324978230198
$ 
```