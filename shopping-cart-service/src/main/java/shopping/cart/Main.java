package shopping.cart;

import akka.actor.typed.ActorSystem;
import akka.actor.typed.Behavior;
import akka.actor.typed.javadsl.AbstractBehavior;
import akka.actor.typed.javadsl.ActorContext;
import akka.actor.typed.javadsl.Behaviors;
import akka.actor.typed.javadsl.Receive;
import akka.management.cluster.bootstrap.ClusterBootstrap;
import akka.management.javadsl.AkkaManagement;
import shopping.cart.proto.ShoppingCartService;

public class Main extends AbstractBehavior<Void> {

    public static void main(String[] args) throws Exception {
        ActorSystem<Void> system = ActorSystem.create(Main.create(), "ShoppingCartService");
    }

    public static Behavior<Void> create() {
        return Behaviors.setup(Main::new);
    }

    public Main(ActorContext<Void> context) {
        super(context);

        ActorSystem<?> system = context.getSystem();

        AkkaManagement.get(system).start();
        ClusterBootstrap.get(system).start();


        ShoppingCart.init(system);


        String grpcInterface =
                system.settings().config().getString("shopping-cart-service.grpc.interface");
        int grpcPort = system.settings().config().getInt("shopping-cart-service.grpc.port");
        ShoppingCartService grpcService = new ShoppingCartServiceImpl(system);
        ShoppingCartServer.start(grpcInterface, grpcPort, system, grpcService);
    }

    @Override
    public Receive<Void> createReceive() {
        return newReceiveBuilder().build();
    }
}
