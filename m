Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C5AC77B60
	for <linux-bcachefs@archiver.kernel.org>; Wed, 26 Apr 2023 07:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239432AbjDZH3E (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 26 Apr 2023 03:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbjDZH3D (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 26 Apr 2023 03:29:03 -0400
Received: from relay-b03.edpnet.be (relay-b03.edpnet.be [212.71.1.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2265E10F3
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Apr 2023 00:29:01 -0700 (PDT)
X-ASG-Debug-ID: 1682494139-15c4354f8014ad940001-qsCQDO
Received: from linuxserver.costadelsollie.local (213.219.188.14.adsl.dyn.edpnet.net [213.219.188.14]) by relay-b03.edpnet.be with ESMTP id Z0HCIePTsD3Lrc8W; Wed, 26 Apr 2023 09:28:59 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 213.219.188.14.adsl.dyn.edpnet.net[213.219.188.14]
X-Barracuda-Apparent-Source-IP: 213.219.188.14
From:   Janpieter Sollie <janpieter.sollie@kabelmail.de>
To:     linux-bcachefs@vger.kernel.org
Cc:     Janpieter Sollie <janpieter.sollie@edpnet.be>,
        Janpieter Sollie <janpieter.sollie@kabelmail.de>
Subject: [PATCH] add --data_types for bcachefs device add
Date:   Wed, 26 Apr 2023 09:28:58 +0200
X-ASG-Orig-Subj: [PATCH] add --data_types for bcachefs device add
Message-Id: <20230426072858.7236-1-janpieter.sollie@kabelmail.de>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: 213.219.188.14.adsl.dyn.edpnet.net[213.219.188.14]
X-Barracuda-Start-Time: 1682494139
X-Barracuda-URL: https://212.71.1.220:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 1936
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.107946
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------------------------
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

From: Janpieter Sollie <janpieter.sollie@edpnet.be>

bcachefs format allows to specify data types allowed on a specific device
but this currently is not available when adding a device with bcachefs format.
The patch adds this functionality.  It is kept as minimal as possible,
in the future the device specific OPTS from cmd_format should be imported
instead of specifying them a 2nd time here

Signed-off-by: Janpieter Sollie <janpieter.sollie@kabelmail.de>
---
 cmd_device.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/cmd_device.c b/cmd_device.c
index c59d370..2da9b87 100644
--- a/cmd_device.c
+++ b/cmd_device.c
@@ -51,6 +51,7 @@ static void device_add_usage(void)
 	     "  -B, --bucket=size           Bucket size\n"
 	     "  -D, --discard               Enable discards\n"
 	     "  -l, --label=label           Disk label\n"
+	     "  -a, --data_allowed=types    allowed data on this device\n"
 	     "  -f, --force                 Use device even if it appears to already be formatted\n"
 	     "  -h, --help                  Display this help and exit\n"
 	     "\n"
@@ -64,6 +65,7 @@ int cmd_device_add(int argc, char *argv[])
 		{ "bucket",		required_argument,	NULL, 'B' },
 		{ "discard",		no_argument,		NULL, 'D' },
 		{ "label",		required_argument,	NULL, 'l' },
+		{ "data_allowed",	required_argument,	NULL, 'a' },
 		{ "force",		no_argument,		NULL, 'f' },
 		{ "help",		no_argument,		NULL, 'h' },
 		{ NULL }
@@ -90,6 +92,10 @@ int cmd_device_add(int argc, char *argv[])
 		case 'l':
 			dev_opts.label = strdup(optarg);
 			break;
+                case 'a':
+                        dev_opts.data_allowed = bch2_read_flag_list(optarg, bch2_data_types);
+                        if(dev_opts.data_allowed == (u64) -1) die("invalid data_allowed types for device - aborting");
+                        break;
 		case 'f':
 			force = true;
 			break;
-- 
2.39.1

