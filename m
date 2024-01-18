Received: from mail-108-mta190.mxroute.com (mail-108-mta190.mxroute.com [136.175.108.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1868BA2B
	for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jan 2024 03:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705548379; cv=none; b=Ic1Qg8RN825IEg9uEPT5KFwg7E3E1NQUAEtaI0Pp6dZWFwuPn0w/JVEO9lsRss+JXIMe3Dyx7aGMYWuGVlg1NjmAtQKghnABB4dpHNbuJYcAsJrJtbTluZ07zHlpeo8ZdT3Q4FO85vGVd1aiUan2sXAJpQ1LsEoTB1FDMyv/DYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705548379; c=relaxed/simple;
	bh=rGdAesDSzSftNr4T7c/BhqESkbTb6xbDRRRW9UI30xQ=;
	h=Received:X-Zone-Loop:X-Originating-IP:DKIM-Signature:References:
	 User-agent:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type:X-Authenticated-Id; b=rHKdHQO9CJ7LMV69w6z4ugjuby4J4hZyhI1BLmhAAe93I+pvtjiE93J15pimueDkTTohFA59M5LfALRdG5ZhdYr/BIW0zbDRNIInVFxueXf5Ev5Ug2G+wdaLhcNgKWmHm+G7Uymsnu6271foGuhSvuCxS2yjqehgAgoLaO0oHbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=TTUQE9gn; arc=none smtp.client-ip=136.175.108.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="TTUQE9gn"
Received: from filter006.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta190.mxroute.com (ZoneMTA) with ESMTPSA id 18d1a961cef0003727.004
 for <linux-bcachefs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Thu, 18 Jan 2024 03:21:01 +0000
X-Zone-Loop: d038bbe40767f4c00dd8426017d08bead5b32faa58e3
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:In-reply-to:Date:Subject:Cc:To:
	From:References:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7Jv0ncTMuPmhr68q4kbNwyzle6PgT1ciB9M9807Jgx0=; b=TTUQE9gnty3qbue5sojJADNiXL
	sgwbhH1YEYTAEzzn+F8Bx6wQkQOX8LXlICv7sC9OvX7lC3uWq2zNmxi5IB3+80HANifFXNPP9uroZ
	0kwea/Dein6qXB+6o494c7m8oYFeRTjJHaG57GkVqvIel80uj+DuwdwyOfBoH2tSd0w4WmwFdWH32
	mtbT3905nhiOkIaXbfFjbOfmup58DpmUPv4YLjBldLzph3mnPqap8NDjFyieI45YBTma/JlRLc96B
	WyFviXVmrasLdRJSD+MM/BGGqP0CoGaasn7S2xhMr3gTqGRDAQhFeWWC5nxpRG4EVFB7RKMPNw8o3
	fZKBKCcg==;
References: <20240117092309.1134595-1-glass.su@suse.com>
 <20240117092309.1134595-2-glass.su@suse.com> <ZagUdl+DlxIw+siv@bfoster>
User-agent: mu4e 1.7.5; emacs 28.2
From: Su Yue <l@damenly.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Su Yue <glass.su@suse.com>, fstests@vger.kernel.org,
 linux-bcachefs@vger.kernel.org, l@damenly.org
Subject: Re: [PATCH v2 2/2] common/rc: improve block size support for bcachefs
Date: Thu, 18 Jan 2024 10:59:14 +0800
In-reply-to: <ZagUdl+DlxIw+siv@bfoster>
Message-ID: <h6jb49cm.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org


On Wed 17 Jan 2024 at 12:55, Brian Foster <bfoster@redhat.com> 
wrote:

> On Wed, Jan 17, 2024 at 05:23:09PM +0800, Su Yue wrote:
>> For bcachefs, def_blksz is never assigned even MKFS_OPTIONS 
>> contains option
>> '--block_size'. So block size of bcachefs on scratch dev is 
>> always 4096
>> if _scratch_mkfs_sized is called without second parameter.
>>
>> Add the pattern to set def_blksz if '--block_size' is given in 
>> MKFS_OPTIONS.
>>
>> Signed-off-by: Su Yue <glass.su@suse.com>
>> ---
>> changelog:
>> v2:
>>     Born.
>> ---
>>  common/rc | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/common/rc b/common/rc
>> index 31c21d2a8360..6a01de69cf05 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -950,6 +950,9 @@ _scratch_mkfs_sized()
>>  	jfs)
>>  		def_blksz=4096
>>  		;;
>> +	bcachefs)
>> +		def_blksz=`echo $MKFS_OPTIONS | sed -rn 
>> 's/.*(--block_size)[ =]?+([0-9]+).*/\2/p'`
>> +		;;
>
> So if the default bcachefs block size is 512b, I wonder if this 
> should
> do something like what the udf branch does a few lines above and
>
mkfs.bcachefs decides block size by querying statbuf.st_blksize or
BLKPBSZGET from the device if the option is not given.

> override the hardcoded default of 4k. ISTM this whole thing 
> would be
> more robust if it just elided the param in the default cases and 
> let the
> associated mkfs tool use its own default, but that's probably a 
> separate
> issue. Hm?
>
Since there is no default block size of bcachefs, maybe we can let
mkfs.bcachefs decide on its own but it will make chaos when 
somebody
reports an unreproducible BUG due to the different block_size even
we have same local.config. It just happened...
So for now, I think 4096 is a resonable value of bcachefs block 
size.

--
Su
>
> Brian
>
>>  	esac
>>
>>  	[ -n "$def_blksz" ] && blocksize=$def_blksz
>> --
>> 2.43.0
>>
