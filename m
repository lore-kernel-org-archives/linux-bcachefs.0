Received: from rivercloud.ext.redscript.org (rivercloud.ext.redscript.org [181.214.58.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8A11EB3D
	for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 03:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=181.214.58.244
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729741985; cv=none; b=gJMpqjSteKqVBUbYe3tINVlJtAcVXNGJVFrIXgg5c1uUNc0Cb22+zww1wa53FteFbrdGVRkLEyl3KUNYZWRWyL1Ag/xoWC7yFwWJLIpMuc9an76EegLMdT6rOMbVu8/OzbNX5PoVrqQqFuQWQ4uJ/jvkhuN0Ogknqqwg0NGPsTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729741985; c=relaxed/simple;
	bh=CeAtJ95YXrA2oRhjpyRRUbD2TJ0iQX5gTRNv2KjWV4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VV8VsdNDMmSPBH2zwzVljAH0rlU78VK+OLf+dWEnHzA2LuvkPmXeVv7wY01eOnulWOaE25LP06KqOAN3T61ROvJicMvCB2/vJNg9ODU4DC5Y5csWOFyO84Qe5f2pk2oTkIwqbYN++CxlNlhByxlkanUL/+eJ/lZ6fCISkokG+Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redscript.org; spf=pass smtp.mailfrom=redscript.org; dkim=pass (1024-bit key) header.d=redscript.org header.i=@redscript.org header.b=UrJDgI3Q; dkim=permerror (0-bit key) header.d=redscript.org header.i=@redscript.org header.b=LT5mDgaF; arc=none smtp.client-ip=181.214.58.244
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redscript.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redscript.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redscript.org header.i=@redscript.org header.b="UrJDgI3Q";
	dkim=permerror (0-bit key) header.d=redscript.org header.i=@redscript.org header.b="LT5mDgaF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redscript.org;
	s=mail2-rsa-2024; t=1729741572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=li/nj3g5UReTcxKqOb6Pt51c7CF3lY5aWfKG4fx6KuM=;
	b=UrJDgI3QQ7zr++/BNXtC0UFKjoAXdNl/ZyBZKVFdIjr42JcQKlrpo6JHCCQe/33+iuvUKR
	gj88rWdkxp6hwn31xqbMfdx+fStwducuXxzGQHoFFMZUwurqye6XH42peb75epZMkGrBN0
	PoDA4mhZxpdo85wZMO2jxmBwHQylI1Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=redscript.org;
	s=mail2-ed25519-2024; t=1729741572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=li/nj3g5UReTcxKqOb6Pt51c7CF3lY5aWfKG4fx6KuM=;
	b=LT5mDgaFj+Lr/SBjxtCl9Z5npbt5uB7mKG6MAcqHza7ikLpi+1C877cGQla2VUA5nLSaOq
	gi9g+HxtPpK5daAg==
Received: 
	by rivercloud.ext.redscript.org (OpenSMTPD) with ESMTPSA id 5c3c711b (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 24 Oct 2024 03:46:11 +0000 (UTC)
Message-ID: <92dce846-d110-4c97-afd1-0b198c1fdf4d@redscript.org>
Date: Thu, 24 Oct 2024 07:46:07 +0400
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: Allocator now directly wakes up copygc when
 necessary
To: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org
Cc: syzbot+7bf808f7fe4a6549f36e@syzkaller.appspotmail.com
References: <20241019215605.160125-1-kent.overstreet@linux.dev>
Content-Language: en-US
From: Ahmad Draidi <a.r.draidi@redscript.org>
In-Reply-To: <20241019215605.160125-1-kent.overstreet@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Greetings,


On 10/20/24 01:56, Kent Overstreet wrote:
> copygc tries to wait in a way that balances waiting for work to
> accumulate with running before we run out of free space - but for a
> variety of reasons (multiple devices, io clock slop, the vagaries of
> fragmentation) this isn't completely reliable.
>
> So to avoid getting stuck, add direct wakeups from the allocator to the
> copygc thread when we start to notice we're low on free buckets.

Since I switched to 6.11.x from 6.10.x, I've had "Allocator stuck? 
Waited for 30 seconds" messages and I/O would stop to the FS. No timeout 
on read, for example, but it just stops for hours, until I reboot. I'm 
able to quickly and reliably trigger this with my workload.


I applied this patch on top of 6.11.4 but can still see "Allocator 
stuck" in dmesg. I see the following before and after the patch:-

"BUG: unable to handle page fault for address: fffffffffffff81b
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page"

...

"RIP: 0010:bch2_btree_path_peek_slot+0x64/0x210 [bcachefs]"


A longer log snippet of "allocator stuck" and the above are at: 
https://pastebin.com/ptuzaryi


I did fsck after FS got stuck, and errors were found and fixed, but 
issue happens again, before and after the patch.

Some info that might be needed: I'm using ECC RAM, 2x SAS SSDs, 2x SATA 
HDDs, LUKS, and the following opts:

starting version 1.12: rebalance_work_acct_fix 
opts=metadata_replicas=2,data_replicas=2,metadata_replicas_required=2,data_replicas_required=2,

metadata_checksum=xxhash,data_checksum=xxhash,compression=lz4,background_compression=gzip,metadata_target=ssd,foreground_target=ssd,

background_target=hdd,promote_target=ssd


Let me know if I can help.


Thanks!

Ahmad


