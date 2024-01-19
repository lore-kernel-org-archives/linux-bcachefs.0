Received: from redpilled.dev (redpilled.dev [195.201.122.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE7D54BDA;
	Fri, 19 Jan 2024 22:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.201.122.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705702840; cv=none; b=e4bEzuarJ4Y/60qXqMZxpS7LY7A9X3BmK+WS377JUhoWMYo4ZSsAIzo3ZQbTbufSqntTtxVpoRpxBX61U7yNhQBkWFPhleDxG5VSNlUKQPzoRm8amDsnWFbRexiKmceh1MbEF9Q8awSA40eH1fBoRD8eqdZ1NeMDZf0BIwlRhEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705702840; c=relaxed/simple;
	bh=1yGh0GCLiibhe/Yj4BnNXSiJphJnDALPM2vFlcHw/OU=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=Jq/0bzll5vKbA9GsybFxqIU8AzWfCoEIx5kwC6Sjm6+dAm6Vo3kMlHHtPt1qMnlQ3Cj3DQGNbAj2n5ZhbK8OtnWWIXEv09Agw/UoN1ZUCOFhuLcugSb5hmltpPMz2UF5ll+6efGoHaetn648HyvrozKWrj0F4YIlK0SZVy4OWWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redpilled.dev; spf=pass smtp.mailfrom=redpilled.dev; dkim=pass (1024-bit key) header.d=redpilled.dev header.i=@redpilled.dev header.b=MWZC+UuT; arc=none smtp.client-ip=195.201.122.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=redpilled.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redpilled.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redpilled.dev header.i=@redpilled.dev header.b="MWZC+UuT"
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redpilled.dev;
	s=mail; t=1705702833;
	bh=mbnDyIiVf5E50dfFktZEEA5wjQCTaxqYRqmmy0cjVgM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MWZC+UuTt38VN3GTbHaTX9BX9UlKHSC67V0tcchpS+6KGHkeOXX1sCEhvIaf4rogY
	 +G1qrEm8TD2CWMgWdR0ntG4R0IFEBxBd0g/u2x3A8bVFn84U8a/ufjBzOD2Oqjt2li
	 Rxr/Fp1GVqIcD5PDZ0UyklZgjqvT77Rd37iJs9xo=
Date: Fri, 19 Jan 2024 22:20:32 +0000
From: Mia Kanashi <chad@redpilled.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>, Christoph
 Hellwig <hch@lst.de>
Subject: Re: [BUG] I/O timeouts and system freezes on Kingston A2000 NVME with
 BCACHEFS
In-Reply-To: <c8f441c2-d662-43fc-9e8e-fc847428dbaa@kernel.dk>
References: <54fcc150f287216593b19271f443bf13@redpilled.dev>
 <c8f441c2-d662-43fc-9e8e-fc847428dbaa@kernel.dk>
Message-ID: <7d9c23450fb3fca7e3820c317c24b112@redpilled.dev>
X-Sender: chad@redpilled.dev
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2024-01-19 21:22, Jens Axboe wrote:
> On 1/19/24 5:25 AM, Mia Kanashi wrote:
>> This issue was originally reported here: 
>> https://github.com/koverstreet/bcachefs/issues/628
>> 
>> Transferring large amounts of files to the bcachefs from the btrfs
>> causes I/O timeouts and freezes the whole system. This doesn't seem to
>> be related to the btrfs, but rather to the heavy I/O on the drive, as
>> it happens without btrfs being mounted. Transferring the files to the
>> HDD, and then from it to the bcachefs on the NVME sometimes doesn't
>> make the problem occur. The problem only happens on the bcachefs, not
>> on btrfs or ext4. It doesn't happen on the HDD, I can't test with
>> other NVME drives sadly. The behaviour when it is frozen is like this:
>> all drive accesses can't process, when not cached in ram, so every app
>> that is loaded in the ram, continues to function, but at the moment it
>> tries to access the drive it freezes, until the drive is reset and
>> those abort status messages appear in the dmesg, after that system is
>> unfrozen for a moment, if you keep copying the files then the problem
>> reoccurs once again.
>> 
>> This drive is known to have problems with the power management in the
>> past:
>> https://wiki.archlinux.org/title/Solid_state_drive/NVMe#Troubleshooting
>> But those problems where since fixed with kernel workarounds /
>> firmware updates. This issue is may be related, perhaps bcachefs does
>> something different from the other filesystems, and workarounds don't
>> apply, which causes the bug to occur only on it. It may be a problem
>> in the nvme subsystem, or just some edge case in the bcachefs too, who
>> knows. I tried to disable ASPM and setting latency to 0 like was
>> suggested, it didn't fix the problem, so I don't know. If this is
>> indeed related to that specific drive it would be hard to reproduce.
> 
> From a quick look, looks like a broken drive/firmware. It is suspicious
> that all failed IO is 256 blocks. You could try and limit the transfer
> size and see if that helps:
> 
> # echo 64 > /sys/block/nvme0n1/queue/max_sectors_kb
> 
> Or maybe the transfer size is just a red herring, who knows. The error
> code seems wonky:
> 
>> [  185.384762] nvme0n1: I/O Cmd(0x2) @ LBA 105272408, 256 blocks, I/O 
>> Error (sct 0x3 / sc 0x71)

Changing max_sectors_kb to 64 does indeed seem to fix the issue at the 
first glance, default value is 128.
Also tried changing bcachefs flags during the format 
--btree_node_size=64k --bucket=64k
thought maybe that is related, but that didn't help.
It is really weird that this problem only occurs on bcachefs.
