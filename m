Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F097944E
	for <linux-bcachefs@vger.kernel.org>; Sun, 16 Mar 2025 17:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742146826; cv=none; b=hJHu1ZQFNy6DNvsYOSbfLRM1H8RkpsrCt01wB0G7smZmxib+djqQipLIGxMyyC7adipR7EUj3b0ZwZH69ZHQJ8YiYkbT/U848WmuzHFZoPwgnnmTVWTE0IZYckH4ZucpBj1Q8y+5w+cYSsRBr788IRVY2bMXmI0N1lOb93ceV48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742146826; c=relaxed/simple;
	bh=WWoQYIiqrKGbN3dLwY+e62sAtd7eCuu/Qv8UX2AXUT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PwAUQn+wSYeJcqPVNSHpp6ICA+/YzNUb9bBi4qyGuWdQHKlG5udOfP09f05Avvotvs4uOM8fjdV/x/ex92CNBhMuo1s1Ni3p8yKK35MiIzeWHo9EuMoXPkNTE7v4z50c2kx1di1Ook1TVWqajmu7kLWRV7JOwFyJjVBbf0UBIsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cn76o0KW; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cn76o0KW"
Date: Sun, 16 Mar 2025 13:40:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742146821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dcN37o6aIUsDQ0KPrmOULj5F1f5WNL3YQf9RlO86/r4=;
	b=cn76o0KWR4lBQKR2ZT9v2pGCd9/xiCxYHO6TrETcasuMNMv0AhxRrWr+eF6Kaxgoor8hqF
	eNhYq6DHTdkZujiAC/mqyiVm9icHfYUWIerWYVmSY86eZSZq/5ZTqInOFvVW+R4FxIlb35
	qPOqAzYH2zUtzsJ7AmsomwHurhRJHtU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Remove bch2_enable_encryption() and
 bch2_disable_encryption()
Message-ID: <duiukclonmpspa3mugs6un62me3uu3j6dk2nufabdlz7bfjwsr@rwx4tc2cah5x>
References: <20250316030137.90673-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250316030137.90673-1-ebiggers@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Mar 15, 2025 at 08:01:37PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> These functions are never called, so remove them.

I've had requests for enabling encryption on an existing filesystem, and
I think that is something we should allow - I wrote the code and didn't
hook it up at the time because I wanted to think about safety issues
more.

So I'd rather just #if 0 it out, if the issue was that it was going to
need to be updated for your other cleanups.

bch2_disable_encryption seems to be duplicating code that also exists in
userspace, I don't see any reason for the userspace version to exist,
this one looks cleaner, so let's also not delete that.

I'm applying this instead:

From a5331b44ab612f1609ee980389a8ea677e194d46 Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kent.overstreet@linux.dev>
Date: Sun, 16 Mar 2025 13:39:14 -0400
Subject: [PATCH] bcachefs: #if 0 out (enable|disable)_encryption()

These weren't hooked up, but they probably should be - add some comments
for context.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/fs/bcachefs/checksum.c b/fs/bcachefs/checksum.c
index 23a383577d4c..15de9d794337 100644
--- a/fs/bcachefs/checksum.c
+++ b/fs/bcachefs/checksum.c
@@ -693,6 +693,14 @@ static int bch2_alloc_ciphers(struct bch_fs *c)
 	return 0;
 }
 
+#if 0
+
+/*
+ * This seems to be duplicating code in cmd_remove_passphrase() in
+ * bcachefs-tools, but we might want to switch userspace to use this - and
+ * perhaps add an ioctl for calling this at runtime, so we can take the
+ * passphrase off of a mounted filesystem (which has come up).
+ */
 int bch2_disable_encryption(struct bch_fs *c)
 {
 	struct bch_sb_field_crypt *crypt;
@@ -725,6 +733,10 @@ int bch2_disable_encryption(struct bch_fs *c)
 	return ret;
 }
 
+/*
+ * For enabling encryption on an existing filesystem: not hooked up yet, but it
+ * should be
+ */
 int bch2_enable_encryption(struct bch_fs *c, bool keyed)
 {
 	struct bch_encrypted_key key;
@@ -781,6 +793,7 @@ int bch2_enable_encryption(struct bch_fs *c, bool keyed)
 	memzero_explicit(&key, sizeof(key));
 	return ret;
 }
+#endif
 
 void bch2_fs_encryption_exit(struct bch_fs *c)
 {
diff --git a/fs/bcachefs/checksum.h b/fs/bcachefs/checksum.h
index 43b9d71f2f2b..4ac251c8fcd8 100644
--- a/fs/bcachefs/checksum.h
+++ b/fs/bcachefs/checksum.h
@@ -103,8 +103,10 @@ extern const struct bch_sb_field_ops bch_sb_field_ops_crypt;
 int bch2_decrypt_sb_key(struct bch_fs *, struct bch_sb_field_crypt *,
 			struct bch_key *);
 
+#if 0
 int bch2_disable_encryption(struct bch_fs *);
 int bch2_enable_encryption(struct bch_fs *, bool);
+#endif
 
 void bch2_fs_encryption_exit(struct bch_fs *);
 int bch2_fs_encryption_init(struct bch_fs *);
