Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V4VzxFyw"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69ECCB9
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Dec 2023 05:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701782636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xlsiw5VtALrliAplBpjqlI8HoG3Ys/T2WHKHIcmOka8=;
	b=V4VzxFywwfVM6IKV/JHR/Wt/OedtV3lQuL8GrWN7IE9UBofO0C90YcyFKRyV4JNZ2QdXby
	O1kJxcpNgozugtpSXCC6RE3o+faCv7bKmA/f8/CrZT31hQ4+haKdUly1w31f9twldGuHbT
	kaQ0QnhVFSmJiegi7EYRYVzfJM/AfAQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-Kj-HylqnMriOCNXQtz2DIQ-1; Tue, 05 Dec 2023 08:23:44 -0500
X-MC-Unique: Kj-HylqnMriOCNXQtz2DIQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB620108BE91
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Dec 2023 13:23:43 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.38])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9095B492BE6
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Dec 2023 13:23:43 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH 1/2] bcachefs: don't attempt rw on unfreeze when shutdown
Date: Tue,  5 Dec 2023 08:24:38 -0500
Message-ID: <20231205132439.130755-2-bfoster@redhat.com>
In-Reply-To: <20231205132439.130755-1-bfoster@redhat.com>
References: <20231205132439.130755-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

The internal freeze mechanism in bcachefs mostly reuses the generic
rw<->ro transition code. If the fs happens to shutdown during or
after freeze, a transition back to rw can fail. This is expected,
but returning an error from the unfreeze callout prevents the
filesystem from being unfrozen.

Skip the read write transition if the fs is shutdown. This allows
the fs to unfreeze at the vfs level so writes will no longer block,
but will still fail due to the emergency read-only state of the fs.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/fs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 0d0a37cad2d4..480a61b60724 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1733,6 +1733,9 @@ static int bch2_unfreeze(struct super_block *sb)
 	struct bch_fs *c = sb->s_fs_info;
 	int ret;
 
+	if (test_bit(BCH_FS_emergency_ro, &c->flags))
+		return 0;
+
 	down_write(&c->state_lock);
 	ret = bch2_fs_read_write(c);
 	up_write(&c->state_lock);
-- 
2.42.0

