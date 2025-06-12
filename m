Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8E829ACE4
	for <linux-bcachefs@vger.kernel.org>; Thu, 12 Jun 2025 15:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749742061; cv=none; b=ZEvHRH2vvA3RsXXI+Q76OCvBSqFjsq8AcVIYkMSzdLW6yeIEU0//HEFJpIqEKZDinXFvzRC+CpR0U71M7m0RDpTNERjXsTvNwvQSsgcKsl+deqY849Px6TcdyyhWJOwPA42yD4DAFoXeW7bxbwKBkRvPfPHdZ06QUXj1xPVIh6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749742061; c=relaxed/simple;
	bh=esuWoF4+5YSzorn3pD3qgA/Q6prQMzRn7YoirPdkwGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ji19A5gtDmlFakuWbV/IzWit3qV4MAtsiqI3vGn+UbXOn8dFGvsaOmsgW7Cx0syVSIoUGlAqQ0dgXbeU8IV2Lb7QazaHp6LuBMBIsqrPG14UFzJmGVUWCUFu49PIn4V9D7SCEk5ouVMDnzt6AyVLqaHdRxfCApZiZInGFL3BwrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tQ2BBo8I; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tQ2BBo8I"
Date: Thu, 12 Jun 2025 11:27:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749742056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=08IhqjOYS8NhpwOoqkODfXYHq76eNMAzxpdSMQvwlzE=;
	b=tQ2BBo8IZP4++LYAWvzkW8nFdDKhmcM78bX6gkBqyb9LbN29WQ35Q31/RW6e+dAONNZrVq
	92TnNzFy2I5mAp7RfSl7YINC/69Te+qD/3biYnw4SsANIZiRe+OSzsqnRuvZV+HXy2L6YI
	YKbwu4MouK0vyWi8uCuUgZp7E0eCa1w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Sergio Perez Gonzalez <sperezglz@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	shuah@kernel.org, syzbot+e577022d4fba380653be@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: fix size used to calculate `nr` of devices in
 member_to_text()
Message-ID: <4n6rpfi4vi4gsrk3oiodqhjtjzaygkgg3yamsmn76trrw4o3zv@xxndklof3j6r>
References: <20250612081935.161598-1-sperezglz@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612081935.161598-1-sperezglz@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 12, 2025 at 02:19:26AM -0600, Sergio Perez Gonzalez wrote:
> In bch2_sb_members_v1_to_text() there is an incorrect size used to
> calculate the number of devices.
> 
> The correct size should be `BCH_MEMBER_V1_BYTES` as implied by:
> 
> static struct bch_member *members_v1_get_mut(struct bch_sb_field_members_v1 *mi, int i)
> {
> 	return (void *) mi->_members + (i * BCH_MEMBER_V1_BYTES);
> }
> 
> Also invert the pointers used in the calculation, given that they yield a
> negative number.
> 
> Reported-by: syzbot+e577022d4fba380653be@syzkaller.appspotmail.com
> Signed-off-by: Sergio Perez Gonzalez <sperezglz@gmail.com>
> ---
>  fs/bcachefs/sb-members.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
> index c673e76ca27f..cc51313ebcf6 100644
> --- a/fs/bcachefs/sb-members.c
> +++ b/fs/bcachefs/sb-members.c
> @@ -325,10 +325,10 @@ static void bch2_sb_members_v1_to_text(struct printbuf *out, struct bch_sb *sb,
>  {
>  	struct bch_sb_field_members_v1 *mi = field_to_type(f, members_v1);
>  	struct bch_sb_field_disk_groups *gi = bch2_sb_field_get(sb, disk_groups);
> -	int nr = (vstruct_end(&mi->field) - (void *) &gi->entries[0]) / sizeof(gi->entries[0]);
> +	int nr = ((void *) &gi->entries[0] - vstruct_end(&mi->field)) / BCH_MEMBER_V1_BYTES;
>  

Actually, this shouldn't be referencing gi at all - brainfart on my end,
that's a completely different superblock section. That's where the
negative number came from.

>  	if (nr != sb->nr_devices)
> -		prt_printf(out, "nr_devices mismatch: have %i entries, should be %u", nr, sb->nr_devices);
> +		prt_printf(out, "nr_devices mismatch: have %i entries, should be %u\n", nr, sb->nr_devices);

Yeah, it should have a newline.

I'll fold that in.

>  
>  	for (int i = 0; i < nr; i++)
>  		member_to_text(out, members_v1_get(mi, i), gi, sb, i);
> @@ -344,10 +344,10 @@ static void bch2_sb_members_v2_to_text(struct printbuf *out, struct bch_sb *sb,
>  {
>  	struct bch_sb_field_members_v2 *mi = field_to_type(f, members_v2);
>  	struct bch_sb_field_disk_groups *gi = bch2_sb_field_get(sb, disk_groups);
> -	int nr = (vstruct_end(&mi->field) - (void *) &gi->entries[0]) / le16_to_cpu(mi->member_bytes);
> +	int nr = ((void *) &gi->entries[0] - vstruct_end(&mi->field)) / le16_to_cpu(mi->member_bytes);
>  
>  	if (nr != sb->nr_devices)
> -		prt_printf(out, "nr_devices mismatch: have %i entries, should be %u", nr, sb->nr_devices);
> +		prt_printf(out, "nr_devices mismatch: have %i entries, should be %u\n", nr, sb->nr_devices);
>  
>  	/*
>  	 * We call to_text() on superblock sections that haven't passed
> -- 
> 2.43.0
> 
