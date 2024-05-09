package com.github.mdeluise.plantit.broker;

import java.io.IOException;
import java.util.concurrent.TimeoutException;

import com.rabbitmq.client.AMQP;
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.DeliverCallback;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class BrokerService {
    private final String queueName = "queue_";
    private final Logger logger = LoggerFactory.getLogger(BrokerService.class);

    public void createQueue(String username) throws IOException, TimeoutException {
        final ConnectionFactory factory = new ConnectionFactory();
        factory.setHost("localhost");
        try (final Connection connection = factory.newConnection();
            final Channel channel = connection.createChannel()) {
            final String queueUsernameName = getQueueName(username);
            final AMQP.Queue.DeclareOk declareOk =
                channel.queueDeclare(queueUsernameName, false, false, false, null);
            if (declareOk != null && declareOk.getQueue() != null) {
                logger.debug("Queue {} already exists, no need to create.", queueUsernameName);
            } else {
                logger.debug("Queue {} does not exist, create it.", queueUsernameName);
            }
        }
    }

    public void startReceiving(String username, DeliverCallback callback) throws IOException, TimeoutException {
        final ConnectionFactory factory = new ConnectionFactory();
        factory.setHost("localhost");
        final Connection connection = factory.newConnection();
        final Channel channel = connection.createChannel();
        final String queueUsernameName = getQueueName(username);
        channel.queueDeclare(queueUsernameName, false, false, false, null);
        logger.debug("Start listening on queue {}", queueUsernameName);
        channel.basicConsume(queueUsernameName, true, callback, consumerTag -> { });
    }


    private String getQueueName(String username) {
        return queueName + username;
    }
}
