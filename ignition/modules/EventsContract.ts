import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const nftAddr = "0x9f3F341FdbC9644C095136Bfb869AEf23ACD5F37";

const EventsContractModule = buildModule("EventsContractModule", (m) => {
  const nftContractAddress = m.getParameter("unlockTime", nftAddr);

  const eventsContract = m.contract("EventsManager", [nftContractAddress]);

  return { eventsContract };
});

export default EventsContractModule;
