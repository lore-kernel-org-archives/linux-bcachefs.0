Received: from cdw.me.uk (cdw.me.uk [91.203.57.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16797F9
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Dec 2023 06:15:10 -0800 (PST)
Received: from chris by delta.arachsys.com with local (Exim 4.80)
	(envelope-from <chris@arachsys.com>)
	id 1rBy6m-00040m-IV
	for linux-bcachefs@vger.kernel.org; Sat, 09 Dec 2023 14:15:08 +0000
Date: Sat, 9 Dec 2023 14:15:08 +0000
From: Chris Webb <chris@arachsys.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs-tools: Guard the __struct_group() #define in
 kernel.h
Message-ID: <e89c20fd7efdba920804749d08c337be50aa57f1.1702131070.git.chris@arachsys.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Our include/linux/byteorder.h uses the system <asm/byteorder.h>
because we don't provide our own in include/asm. This then pulls in
system <linux/stddef.h> which defines __struct_group. That definition
collides with the unconditional #define __struct_group in our local
include/linux/kernel.h, provoking preprocessor warnings.

Signed-off-by: Chris Webb <chris@arachsys.com>
---
 include/linux/kernel.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 6315e53..6f56748 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -99,11 +99,14 @@
 	(type *)((char *)__mptr - offsetof(type, member)); })
 #endif
 
+#ifndef __struct_group
 #define __struct_group(TAG, NAME, ATTRS, MEMBERS...) \
 	union { \
 		struct { MEMBERS } ATTRS; \
 		struct TAG { MEMBERS } ATTRS NAME; \
 	}
+#endif
+
 #define struct_group(NAME, MEMBERS...)	\
 	__struct_group(/* no tag */, NAME, /* no attrs */, MEMBERS)
 
