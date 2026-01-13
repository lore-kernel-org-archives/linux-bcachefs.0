Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C40A2222C4
	for <linux-bcachefs@vger.kernel.org>; Tue, 13 Jan 2026 19:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768334196; cv=none; b=TOCEj3zy++FH2juC7PC2HfjyaRMQU+tEvwuMBEf2B4F73BOYfJ6F/4hJfYbDcfkshV8n4DqtVJIR75tsX7wE1r6+1nEoE1gvv50DO+agTV0uUfQ2Y+RG3r8oQ91fCTVQ3G106lmlhvo/p3lyAMTHyXcBuA/eC2s1OqE75dKapRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768334196; c=relaxed/simple;
	bh=p8L9Ys+La7M536PdDDXjwas5ucwyNTgpgHHvjwPVNQo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PzXMpCWuD5Kzi1rVVzIupfwspB2MlbVHyu5+/WdO6jP2m6eR9Wp3rSR0k8r9SgGgxB/cbqH/TDZwTsgp2CEpzcvL0h0ZhlHuQNmZ29suLtXxxh4YD5gM6G7RE3efMysjadSOCEYd+E87ODO/Jb5X1T2ElRZJ0683E2jcYp9Lu8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 65534)
	id C8C4E1004F473B; Tue, 13 Jan 2026 20:56:26 +0100 (CET)
X-Spam-Level: 
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:202:600a::a4])
	by a3.inai.de (Postfix) with ESMTP id ABF561003E66D7;
	Tue, 13 Jan 2026 20:56:26 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@linux.dev
Subject: [PATCH] doc: fix spello in cmd_device.c
Date: Tue, 13 Jan 2026 20:56:25 +0100
Message-ID: <20260113195625.73764-1-jengelh@inai.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Partial revert of cd214bdc877674a8dcb21dca88851d586ffc2a3a which
hypercorrected a percevied spello.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 c_src/cmd_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/c_src/cmd_device.c b/c_src/cmd_device.c
index ceafa98a..646950c1 100644
--- a/c_src/cmd_device.c
+++ b/c_src/cmd_device.c
@@ -205,7 +205,7 @@ static int cmd_device_remove(int argc, char *argv[])
 
 static void device_online_usage(void)
 {
-	puts("bcachefs device online - read a device to a running filesystem\n"
+	puts("bcachefs device online - re-add a device to a running filesystem\n"
 	     "Usage: bcachefs device online [OPTION]... <device>\n"
 	     "\n"
 	     "Options:\n"
-- 
2.52.0

