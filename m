Received: from cdw.me.uk (cdw.me.uk [91.203.57.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BF6910D0
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Dec 2023 04:58:47 -0800 (PST)
Received: from chris by delta.arachsys.com with local (Exim 4.80)
	(envelope-from <chris@arachsys.com>)
	id 1rBwus-0001v4-Pr
	for linux-bcachefs@vger.kernel.org; Sat, 09 Dec 2023 12:58:46 +0000
Date: Sat, 9 Dec 2023 12:58:46 +0000
From: Chris Webb <chris@arachsys.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs-tools: Use basename(3) from <libgen.h>
Message-ID: <9cd6c15a5049030d5c8aefc0bad4c1159525c18d.1702126622.git.chris@arachsys.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Although glibc also provides basename(3) from <string.h>, this is
non-standard whereas it is available from <libgen.h> portably.

Signed-off-by: Chris Webb <chris@arachsys.com>
---
 libbcachefs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libbcachefs.c b/libbcachefs.c
index 82f131c..a3b9c30 100644
--- a/libbcachefs.c
+++ b/libbcachefs.c
@@ -2,6 +2,7 @@
 #include <dirent.h>
 #include <errno.h>
 #include <fcntl.h>
+#include <libgen.h>
 #include <stdbool.h>
 #include <stdint.h>
 #include <stdio.h>
