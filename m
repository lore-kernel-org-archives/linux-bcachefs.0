Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HeK3txOi"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE55B7;
	Sat,  9 Dec 2023 22:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=wqSeEPanlXlOG/9n9u5KnVzekwZYv7zZQyTmk5eD/Ks=; b=HeK3txOiVsoFp2/rXM+EwnnWS+
	EB+/qc5gdMOAAT6nF+KS7y7zB1iLp5+R538d9O1aOLSeWDO2IyzCBQgpVmkGn/DpMmELroTbK6Xlz
	gaUZB/DSVZ5HJ0mc7eOuQph5nVnqUvT9wsI1O4V8bhPckEp1/O3TgE1jDQBkU2fkjzajfni2R9fAp
	0xht4IP9v2/j40pH13qifSaUoZrTpk4wTa3pnECaoYYTlou7q5U/rokdVcsPDYqbLAwdmAXrDHQ5H
	m3HS1GvJC7eBE1ueQhGPJKS9mRC3/mRPgydN9IS3L8hx4BRabL/VJVuYs99m7SD8KwU84PhROoIkf
	GaS5JJKw==;
Received: from [50.53.46.231] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCCxh-00119d-0K;
	Sun, 10 Dec 2023 06:06:45 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: six lock: fix typos
Date: Sat,  9 Dec 2023 22:06:44 -0800
Message-ID: <20231210060644.26978-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a few typos in the six.h header file.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
---
 fs/bcachefs/six.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -- a/fs/bcachefs/six.h b/fs/bcachefs/six.h
--- a/fs/bcachefs/six.h
+++ b/fs/bcachefs/six.h
@@ -15,7 +15,7 @@
  * will have to take write locks for the full duration of the operation.
  *
  * But by adding an intent state, which is exclusive with other intent locks but
- * not with readers, we can take intent locks at thte start of the operation,
+ * not with readers, we can take intent locks at the start of the operation,
  * and then take write locks only for the actual update to each individual
  * nodes, without deadlocking.
  *
@@ -65,8 +65,8 @@
  *
  * Reentrancy:
  *
- *   Six locks are not by themselves reentrent, but have counters for both the
- *   read and intent states that can be used to provide reentrency by an upper
+ *   Six locks are not by themselves reentrant, but have counters for both the
+ *   read and intent states that can be used to provide reentrancy by an upper
  *   layer that tracks held locks. If a lock is known to already be held in the
  *   read or intent state, six_lock_increment() can be used to bump the "lock
  *   held in this state" counter, increasing the number of unlock calls that
