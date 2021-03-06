<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright 2015 Red Hat, Inc. and/or its affiliates
    and other contributors as indicated by the @author tags.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xalan"
                xmlns:ra="urn:jboss:domain:resource-adapters:2.0"
                version="2.0"
                exclude-result-prefixes="xalan ra">

  <!-- will indicate if this is a "dev" build or "production" build -->
  <xsl:param name="kettle.build.type"/>

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" xalan:indent-amount="4" standalone="no"/>
  <xsl:strip-space elements="*"/>

  <!-- add system properties -->
  <xsl:template name="system-properties">
    <system-properties>
      <property name="hawkular-metrics.backend" value="embedded_cass" />
    </system-properties>
  </xsl:template>

  <xsl:template match="node()[name(.)='extensions']">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
    <xsl:call-template name="system-properties"/>
  </xsl:template>

  <!-- add our JMS queues/topices that are required to be defined as admin-objects -->
  <xsl:template name="admin-objects">
    <admin-objects>
      <admin-object use-java-context="true"
                    enabled="true"
                    class-name="org.apache.activemq.command.ActiveMQTopic"
                    jndi-name="java:/topic/HawkularNotifications"
                    pool-name="HawkularNotifications">
        <config-property name="PhysicalName">HawkularNotifications</config-property>
      </admin-object>
      <admin-object use-java-context="true"
                    enabled="true"
                    class-name="org.apache.activemq.command.ActiveMQTopic"
                    jndi-name="java:/topic/HawkularMetricData"
                    pool-name="HawkularMetricData">
        <config-property name="PhysicalName">HawkularMetricData</config-property>
      </admin-object>
    </admin-objects>
  </xsl:template>

  <xsl:template match="ra:admin-objects">
    <xsl:call-template name="admin-objects"/>
  </xsl:template>

  <!-- copy everything else as-is -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
