Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73132441D
	for <linux-bcachefs@vger.kernel.org>; Tue,  4 Jun 2024 02:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717466526; cv=none; b=lWfaxTnZm9V78sSBaL+McoKhUhyuhTv5MIiVvEPTnZjQ+5LoZs7YUvxb2fPptuYKO2eZptTb7y1pasUr+wy+JjvRTkrIvuckIhzNSrEbVfOrm0J8p5lj64er0ebEL9LjPTY5WftUFUi23tyAsNuj13/rgMjIaow21Z2ATvtUBDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717466526; c=relaxed/simple;
	bh=3aN9Acd2T9sLd4QenwI7mZ3B4iIR9lST1hSFryxOML4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nlQo4e6nvY10kKRdQJKNxtS7eUyj5YfgUn/Pf68tgY20mO78LvQgvkTg1/cjtdk8+PBl1JAbcOgIyLOaayq46ocAUO3gO0xsWei2yiOtC30BOhyxZFmvmpeUmHhopyQphSQjXePfE9WjR9/eKp+LwzMY+/n9G10COZuFumhNpLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rE75durJ; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rE75durJ"
X-Envelope-To: lihongbo22@huawei.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717466516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vM7C5cvKUOmrNVP5DRuUa1Nan3q8aTVseHZvwj0h0kw=;
	b=rE75durJevoaBheLZY5A7t28KMcXKjrlg2I71r5OwvhkMyzLig4j6vxDQrHeDhkc7U4pQp
	vtasfPREd7I/ykOEOCS7aygvq5pilCY8/4aliRbt7jP1ybdNRFosArndA8+v8ThEw06UG/
	K/SVn7DlTDMFTjzO4121ffGYlIk3lqw=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Mon, 3 Jun 2024 22:01:52 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org
Subject: Re: memcpy failed when __bch2_accounting_mem_mod_slowpath
Message-ID: <zeoohvw5qd7ooy5d4ruvoxojylkb5rous7u2nsuoev4b56r7qa@k7b3cijpf6zl>
References: <2d978ffc-ed7b-4039-a713-c885dc8f4d00@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d978ffc-ed7b-4039-a713-c885dc8f4d00@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 04, 2024 at 09:22:51AM +0800, Hongbo Li wrote:
> I found the following issue on:
> 
> HEAD commit: 587f7f5a4765a76f9ea05159963d14f8967cb45b(cmd_list_journal: open
> with noexcl, so we can work on mounted filesystems)
> 
> git tree: master
> git repo: https://github.com/koverstreet/bcachefs-tools.git
> util-linux: 2.37.2
> 
> IMPORTANT: If someone fix this issue, please kindly add the following tag to
> the commit:
> 
> Reported-by: Hongbo Li <lihongbo22@huawei.com>
> 
> [Tue Jun  4 09:16:44 2024] bcachefs (loop1): mounting version 1.9:
> disk_accounting_v2
> [Tue Jun  4 09:16:44 2024] bcachefs (loop1): initializing new filesystem
> [Tue Jun  4 09:16:44 2024] bcachefs (loop1): going read-write
> [Tue Jun  4 09:16:44 2024] bcachefs (loop1): marking superblocks
> [Tue Jun  4 09:16:44 2024] ------------[ cut here ]------------
> [Tue Jun  4 09:16:44 2024] memcpy: detected field-spanning write (size 4) of
> single field "r" at fs/bcachefs/disk_accounting.c:185 (size 3)
> [Tue Jun  4 09:16:44 2024] WARNING: CPU: 6 PID: 11 at

Thanks, this just needs an unsafe_memcpy() annotation


commit 1c39379a4cddbf8d68c588ac9df7149840b9e4ff
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Mon Jun 3 22:01:25 2024 -0400

    fixup! bcachefs: Disk space accounting rewrite

diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
index 48d68db286a3..f118d5614e3a 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -182,7 +182,9 @@ static inline bool accounting_to_replicas(struct bch_replicas_entry_v1 *r, struc
 
 	switch (acc_k.type) {
 	case BCH_DISK_ACCOUNTING_replicas:
-		memcpy(r, &acc_k.replicas, replicas_entry_bytes(&acc_k.replicas));
+		unsafe_memcpy(r, &acc_k.replicas,
+			      replicas_entry_bytes(&acc_k.replicas),
+			      "variable length struct");
 		return true;
 	default:
 		return false;
