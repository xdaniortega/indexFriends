import React from "react";
import ReactDOM from "react-dom";
import { BrowserRouter as Router, Route } from "react-router-dom";

import "./style.css";
import Home from "./views/home";
import AfterLogin from "./views/after-login";
import Balance from "./views/balance";

/////////// IMPORTS FROM WALLETCONNECT ///////////
import { createWeb3Modal, defaultWagmiConfig } from "@web3modal/wagmi/react";

import { WagmiConfig, useAccount } from "wagmi";
import { arbitrum, celoAlfajores, mainnet } from "wagmi/chains";

///////////////////////////////////////////////

const App = () => {
  /////////// WALLETCONNECT CONFIGURATION ///////////
  // 1. Get projectId
  const projectId = "e50f5a657325894d5d2b123fe99e10f6"; //can change to .env file

  // 2. Create wagmiConfig
  const chains = [mainnet, arbitrum, celoAlfajores];
  const wagmiConfig = defaultWagmiConfig({
    chains,
    projectId,
    appName: "indexFriends",
  });

  // 3. Create modal
  createWeb3Modal({
    wagmiConfig,
    projectId,
    chains,
    themeMode: "dark",
    themeVariables: {
      "--w3m-color-mix": "#00BB7F",
      "--w3m-color-mix-strength": 40,
    },
  });

  /////////////////////////////////////////////////
  return (
    <WagmiConfig config={wagmiConfig}>
      <Router>
        <div>
          <Route component={Home} exact path="/" />
          <Route component={AfterLogin} exact path="/after-login" />
          <Route component={Balance} exact path="/balance" />
        </div>
      </Router>
    </WagmiConfig>
  );
};

ReactDOM.render(<App />, document.getElementById("app"));
