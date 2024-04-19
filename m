Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE1413B297
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 18:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713550424; cv=none; b=UT5B26YunvM+IJpk3ptTySc+eZmOoy7zGzZDDkSD8FUYmIziYURfkLalqgYyFzdJ1bt5EdOMPjtd6+PBm7IEBewjaY8h6sXuta6LPql8naQtmSPKs2I9AFchxCWplPc8rP06A+BgT0wpNAH4OwVaGzxhjrtodueix3VNq/6Tm8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713550424; c=relaxed/simple;
	bh=IcJ/TFbm5oifCQWoUL/2P8Jlw08It+P2epk/vdl9G9A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mdmFrodJi9bNgQ+v4k561q8R3escs4nyYCl34N0EXul9r3sIxDS9FNrDrsWCX7jpEI7QbEIyH0jW/iKaTnuUFivYMdvi1Nxz3DJwbG/DxNOTMHDKmTSuTaKyL6tl71Oj48qKjG0dBn1bouPXYhrelRchFARKK7UQxwUQxEAsX2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gIglP9Lg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gIglP9Lg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713550421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Rp68tXtEC47uPgQukdaWGweldIjw3EM6UreKd5Rnyk=;
	b=gIglP9Lgk9ohMW8Oivf8m9EDfDE1ER8A5PSqZsG80vVOB5PwakqA3p0uRFsTJrqvdrR4PY
	1scSWXJLMETDKBG+ChhwRSxs/BXGG8c64eQysNaqqc1Q+/DDB6u0iAWD9lCbArsKTCEaCM
	42C6sWTM1qpCRqTgkEq+cvEgN8aWmjw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81-MBC1jlrPOAmP3WT5IGS9aQ-1; Fri,
 19 Apr 2024 14:13:40 -0400
X-MC-Unique: MBC1jlrPOAmP3WT5IGS9aQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F07B0286A9D6
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 18:13:39 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D4DD943FB1
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 18:13:39 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 2/4] bcachefs: track current fiemap offset in start variable
Date: Fri, 19 Apr 2024 14:15:36 -0400
Message-ID: <20240419181538.1411082-3-bfoster@redhat.com>
In-Reply-To: <20240419181538.1411082-1-bfoster@redhat.com>
References: <20240419181538.1411082-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index f6cd14c9b38c..8b806e33c6c9 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1011,6 +1011,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 		bch2_bkey_buf_realloc(&prev, c, k.k->u64s);
 
 		sectors = min(sectors, k.k->size - offset_into_extent);
+		start = iter.pos.offset + sectors;
 
 		bch2_cut_front(POS(k.k->p.inode,
 				   bkey_start_offset(k.k) +
@@ -1031,8 +1032,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 		bkey_copy(prev.k, cur.k);
 		have_extent = true;
 
-		bch2_btree_iter_set_pos(&iter,
-			POS(iter.pos.inode, iter.pos.offset + sectors));
+		bch2_btree_iter_set_pos(&iter, POS(iter.pos.inode, start));
 
 		ret = bch2_trans_relock(trans);
 		if (ret)
-- 
2.44.0

