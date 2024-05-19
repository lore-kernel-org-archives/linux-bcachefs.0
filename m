Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88058F4A;
	Sun, 19 May 2024 23:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716162536; cv=none; b=DZZ6akIubg9w13WmMrj6XqgttTA10t3CSCZLgFt6O9OFx+D80Uq79BG2v+/EqrjFvwL2xkGcEH7DtyedlWNx+dMVBo5cuuLW/11O3oYZR1UpGVr8VapRzBJEhjcu75FZ6JVyY4OMQcxzyCCqBU6HyBo6l6K1D9u9e4pu7upM5g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716162536; c=relaxed/simple;
	bh=Ocv4cMWN/YJWoYreF+GfL6lTlF1Ai0HbQK1y9mrIcsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qP34VAkG6KnsJPxtveGO6DWxAXl3De7uyaf8tCaKnTWbjcU2lcHhmSUsKKgEzZqEq0871Tgb8b79rWmX7CTPMManZcLdrEOJ82a2jlorhjXnEyB6o+LlFjPPb8yPsMIAC9Hj6rdMn7uY1I6kLEbbMBWXKUhpfT7RewF6sdpOAdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QUqcSwLG; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QUqcSwLG"
X-Envelope-To: cam.alvarez.i@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716162531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YomE77DBn7ISQor+O+BG/IgfWqCbd+m1xARQsjuVbzo=;
	b=QUqcSwLGLaTlyjcOC8DdjeMsQAyN2/X2pAEyUZ+gbOZX04yBscg1O8IfdZLK10Fu482pcr
	60lZ6yjxF8iaBDohE9bw7AwrDtiVgEZwIJGpvH/52HKUfd/ZPgbqmytrWgmQ+Xk9J8fSC+
	qndXyHN4ozf2dqkDTRlsutKRK3Qga1Q=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzbot+249018ea545364f78d04@syzkaller.appspotmail.com
Date: Sun, 19 May 2024 19:48:47 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Camila Alvarez <cam.alvarez.i@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot+249018ea545364f78d04@syzkaller.appspotmail.com
Subject: Re: [PATCH] guard against unknown r->data_type in
 bch2_sb_dev_has_data()
Message-ID: <463goq53266oiymf2bpulp2jczyd37boxifqhem3hhhu5vxn3z@xdjdgmx3htsq>
References: <20240515014720.2482142-1-cam.alvarez.i@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240515014720.2482142-1-cam.alvarez.i@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, May 14, 2024 at 09:47:22PM -0400, Camila Alvarez wrote:
> Shift is perfomed only when the data type makes sense.
> 
> Fix a missing guard on r->data_type being known.
> 
> Reported-by: syzbot+249018ea545364f78d04@syzkaller.appspotmail.com
> Signed-off-by: Camila Alvarez <cam.alvarez.i@gmail.com>

Sorry I just now saw this, already applied a different fix - BCH_DATA_NR
isn't the right guard here, because we need to be able to handle unknown
data types for backwards compatibilicy. 

Here's my version:

commit 85e8b546542c9a1f9050a7f53d92b8bd39c8e9d8
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sun May 19 17:28:44 2024 -0400

    bcachefs: Fix shift overflows in replicas.c
    
    We can't disallow unknown data_types in verify() - we have to preserve
    them unchanged for backwards compat; that means we have to add a few
    more guards.
    
    Reported-by: syzbot+249018ea545364f78d04@syzkaller.appspotmail.com
    Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/replicas.c b/fs/bcachefs/replicas.c
index bd1d5d085e23..d45b10bc531c 100644
--- a/fs/bcachefs/replicas.c
+++ b/fs/bcachefs/replicas.c
@@ -524,13 +524,16 @@ int bch2_replicas_gc_start(struct bch_fs *c, unsigned typemask)
 	c->replicas_gc.nr		= 0;
 	c->replicas_gc.entry_size	= 0;
 
-	for_each_cpu_replicas_entry(&c->replicas, e)
-		if (!((1 << e->data_type) & typemask)) {
+	for_each_cpu_replicas_entry(&c->replicas, e) {
+		/* Preserve unknown data types */
+		if (e->data_type >= BCH_DATA_NR ||
+		    !((1 << e->data_type) & typemask)) {
 			c->replicas_gc.nr++;
 			c->replicas_gc.entry_size =
 				max_t(unsigned, c->replicas_gc.entry_size,
 				      replicas_entry_bytes(e));
 		}
+	}
 
 	c->replicas_gc.entries = kcalloc(c->replicas_gc.nr,
 					 c->replicas_gc.entry_size,
@@ -542,7 +545,8 @@ int bch2_replicas_gc_start(struct bch_fs *c, unsigned typemask)
 	}
 
 	for_each_cpu_replicas_entry(&c->replicas, e)
-		if (!((1 << e->data_type) & typemask))
+		if (e->data_type >= BCH_DATA_NR ||
+		    !((1 << e->data_type) & typemask))
 			memcpy(cpu_replicas_entry(&c->replicas_gc, i++),
 			       e, c->replicas_gc.entry_size);
 
@@ -998,7 +1002,7 @@ unsigned bch2_sb_dev_has_data(struct bch_sb *sb, unsigned dev)
 {
 	struct bch_sb_field_replicas *replicas;
 	struct bch_sb_field_replicas_v0 *replicas_v0;
-	unsigned i, data_has = 0;
+	unsigned data_has = 0;
 
 	replicas = bch2_sb_field_get(sb, replicas);
 	replicas_v0 = bch2_sb_field_get(sb, replicas_v0);
@@ -1006,17 +1010,26 @@ unsigned bch2_sb_dev_has_data(struct bch_sb *sb, unsigned dev)
 	if (replicas) {
 		struct bch_replicas_entry_v1 *r;
 
-		for_each_replicas_entry(replicas, r)
-			for (i = 0; i < r->nr_devs; i++)
+		for_each_replicas_entry(replicas, r) {
+			if (r->data_type >= sizeof(data_has) * 8)
+				continue;
+
+			for (unsigned i = 0; i < r->nr_devs; i++)
 				if (r->devs[i] == dev)
 					data_has |= 1 << r->data_type;
+		}
+
 	} else if (replicas_v0) {
 		struct bch_replicas_entry_v0 *r;
 
-		for_each_replicas_entry_v0(replicas_v0, r)
-			for (i = 0; i < r->nr_devs; i++)
+		for_each_replicas_entry_v0(replicas_v0, r) {
+			if (r->data_type >= sizeof(data_has) * 8)
+				continue;
+
+			for (unsigned i = 0; i < r->nr_devs; i++)
 				if (r->devs[i] == dev)
 					data_has |= 1 << r->data_type;
+		}
 	}
 
 
