Received: from mail-108-mta17.mxroute.com (mail-108-mta17.mxroute.com [136.175.108.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB70F5465D
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jan 2024 23:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706572616; cv=none; b=QnVxYANNuqZTpvP1IolP6jTnctCX7KFO5KgvCbRr45C6PntkVNUMCVLZ4mFmtAsZAxnXPsRw3mYYZW6WEUCbAwO0DqcbwE6+0rdxD43Rb1+L6koMbg3UpOQMUcPIjZ9mjKaB1he8vnO1YU3Vy5s/F8/OuEwv3afR1c3Ecx8SPa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706572616; c=relaxed/simple;
	bh=t2NVk9AF/WPKMvsDs5A/9XWvQWGMS3Sjhhxb+vhM0Lc=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=BVKsoJ0TKmCO0orMKbSUprdsWKgYbeb0nL8Kg3kDcpqtBOvSreQFwslJosA4mnsGfM3XUVlSFEHj+qqkxpBKAC3xPJpkh4RYdBUL00lTQMuLniq5lyClWDoNn/QNQzzq4stW1xMf0/bV0was6lHCuxF9+5TxGhY1/tepAie6lXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=MAcVXnWz; arc=none smtp.client-ip=136.175.108.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="MAcVXnWz"
Received: from filter006.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta17.mxroute.com (ZoneMTA) with ESMTPSA id 18d57a2c7d40003727.004
 for <linux-bcachefs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 29 Jan 2024 23:51:42 +0000
X-Zone-Loop: 6ba7600d022c7c9ca537680435303b762f7b1ff04fc9
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:In-reply-to:Date:Subject:Cc:To:
	From:References:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kpGL7mfYuGZw9u1da5hntT4dbeJRrAAZcd50cO5ixi0=; b=MAcVXnWzqcOyBsAXvv0O0Cmsot
	hXxvD9BFc4hfCwShabmL1OicCPLvGMfvkqPOmLgReWmf5NuYZeoPN0ueRu9wcJIyysX75Um9WhFe4
	b/bhns5eRc5NxZiTE0ud8HM8C2k854WePzBoOTgeo4NJxE2uoIxigbarbP6TmDE8hSMvIEeHC9Uk2
	OXwDCMpGsJJk8mC8o2pWHU/2YNWR1Dma8g3LugpgGXV7UPZadQCn0yySVnKEfcw/6MOn9gdWBWLAC
	Lt05EtVjk2dKelWxZzGGHa3Htt12bMW21rWxmztV3edEzWZG0A7UtYkHXlZ60T7OZhTnXRp078URd
	nybI34Bg==;
References: <20240129140101.4259-1-l@damenly.org>
 <20240129140101.4259-4-l@damenly.org> <ZbfH8nFO12Q0tSIp@bfoster>
User-agent: mu4e 1.7.5; emacs 28.2
From: Su Yue <l@damenly.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Su Yue <glass.su@suse.com>, fstests@vger.kernel.org,
 linux-bcachefs@vger.kernel.org, l@damenly.org
Subject: Re: [PATCH v3 2/2] common/rc: improve block_size support for bcachefs
Date: Tue, 30 Jan 2024 07:44:53 +0800
In-reply-to: <ZbfH8nFO12Q0tSIp@bfoster>
Message-ID: <h6ivhf8j.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org


On Mon 29 Jan 2024 at 10:44, Brian Foster <bfoster@redhat.com> 
wrote:

> On Mon, Jan 29, 2024 at 10:01:01PM +0800, Su Yue wrote:
>> From: Su Yue <glass.su@suse.com>
>>
>> mkfs.bcachefs now supports option '--block_size' to allow
>> custom block_size.
>>
>> Add the pattern to set def_blksz if MKFS_OPTIONS contains the
>> option in _scratch_mkfs_sized.
>> Also let mkfs.bcachefs decide blocksize if no option is given 
>> in
>> local.config or _scratch_mkfs_sized parameter.
>>
>> Signed-off-by: Su Yue <glass.su@suse.com>
>> ---
>> changelog:
>> v3:
>>     Add logic to Let mkfs.bcachefs decide blocksize if no 
>>     option is given in
>>     local.config or _scratch_mkfs_sized parameter.
>> v2:
>>     Born.
>> ---
>
> Looks like the series duplicates the patches for some reason..
>
Yeah..I sent two patches but 4 patches in
https://lore.kernel.org/fstests/20240129140101.4259-3-l@damenly.org/T/#t

>
>>  common/rc | 10 +++++++++-
>>  1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/common/rc b/common/rc
>> index 31c21d2a8360..315a2413f963 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -930,6 +930,7 @@ _scratch_mkfs_sized()
>>  	local fssize=$1
>>  	local blocksize=$2
>>  	local def_blksz
>> +	local blocksize_opt
>>
>>  	case $FSTYP in
>>  	xfs)
>> @@ -950,6 +951,13 @@ _scratch_mkfs_sized()
>>  	jfs)
>>  		def_blksz=4096
>>  		;;
>> +	bcachefs)
>> +		def_blksz=`echo $MKFS_OPTIONS | sed -rn 
>> 's/.*(--block_size)[ =]?+([0-9]+).*/\2/p'`
>> +		[ -n "$def_blksize" ] && 
>> blocksize_opt="--block_size=$def_blksize"
>> +		[ -n "$blocksize" ] && 
>> blocksize_opt="--block_size=$blocksize"
>
> This seems reasonable to me, but if I follow this function 
> correctly the
> behavior when both the param ($blocksize) and MKFS_OPTIONS 
> specify a
> block size is that MKFS_OPTIONS overrides the former. For 
> bcachefs it
> looks like the above does the opposite. Should we switch around 
> the
> above two statements?
>
Thanks for the catch. Nights turned my brain to mush.

V4 was sent.
--
Su
> Brian
>
>> +		# If no block size is given by local.confg or 
>> parameter, blocksize_opt is empty.
>> +		# Let MKFS_BCACHEFS_PROG decide block size on its own.
>> +		;;
>>  	esac
>>
>>  	[ -n "$def_blksz" ] && blocksize=$def_blksz
>> @@ -1051,7 +1059,7 @@ _scratch_mkfs_sized()
>>  		export MOUNT_OPTIONS="-o size=$fssize 
>>  $TMPFS_MOUNT_OPTIONS"
>>  		;;
>>  	bcachefs)
>> -		$MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize 
>> --block_size=$blocksize $SCRATCH_DEV
>> +		$MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize 
>> $blocksize_opt $SCRATCH_DEV
>>  		;;
>>  	*)
>>  		_notrun "Filesystem $FSTYP not supported in 
>>  _scratch_mkfs_sized"
>> --
>> 2.43.0
>>
>>
