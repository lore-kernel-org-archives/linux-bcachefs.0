Received: from mail-108-mta53.mxroute.com (mail-108-mta53.mxroute.com [136.175.108.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F776EBE
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jan 2024 02:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705460245; cv=none; b=HmSowp6kjtASrsi34XY1A0UuRKljzQC1gsr74ZmtiJZ5XDQlCQ0rZpgOfXfQ9Dtn2r9at3QnReqMyljR90T33Ogm4aGKUBD2DAcnZzU9Cbt0hszGD2W7x0wRGlLWE/A5C5s9PfY6rA+xzu+EcQcSprIAaEVGED1gaKhGWzPzeCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705460245; c=relaxed/simple;
	bh=3cKPX6y5Hm5CUWFDUvwe9ICxu/qubX3zGG2Df4frFDw=;
	h=Received:X-Zone-Loop:X-Originating-IP:DKIM-Signature:References:
	 User-agent:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type:X-Authenticated-Id; b=d+ANSeT4eHUaniNC/t+Nq3VzmIGLhneaSpLKOp3AUe1hg6TUvvekkRV+76AgKAxzWYwPnXqYcaLU3aeg2Vo12zC8qVHL+VjJm8ENtondAGlEaQYolTUNe3imogmPW6qfhIhJMvwNT9cW4XsWV33fPTJ5++w5TgwneEjGWI8FRzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=Hd8qQ7W9; arc=none smtp.client-ip=136.175.108.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="Hd8qQ7W9"
Received: from filter006.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta53.mxroute.com (ZoneMTA) with ESMTPSA id 18d155551750003727.004
 for <linux-bcachefs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Wed, 17 Jan 2024 02:52:09 +0000
X-Zone-Loop: 30261635827af77fa58f3ce817699149ab5640064587
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:In-reply-to:Date:Subject:Cc:To:
	From:References:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=H8+/IsfIzQcL1yJxnEfqmBJ8PS60xd8AtQWLh3AOSqE=; b=Hd8qQ7W97iWz5Z7FaYEsqeYl4o
	zH17V4aGkGo/wWZ4klw0oedNteP+Akq1mwug1hTKbxQr2Ry8ZKNmVbOhAgJanAZWdvCLZfIG4t3Uj
	y7C+HL+r+LUyc6tU015PpGI5rRQU7AmIo3CT0uHV9GDzKOUvXL7hQgSVxVDtDV9HYe3aQNFpzDT3X
	5ygC2bV6AYoRJAtV5Rd8v3m840L7mfNL8LXnemTua+Vo/7YaYisTjxLhlLaD82DD40aor2ikqlaWm
	J+Wkm6H6odCBUcdOyNNO5PMtaPDsLY7at+dPklSt3+zw+9GzktUaqMi5yhip+Ej0sU8S0ZdQVtDUN
	JzUCosyA==;
References: <20240114044120.140111-1-glass.su@suse.com>
 <ZaaGkadipvNY02HM@bfoster>
User-agent: mu4e 1.7.5; emacs 28.2
From: Su Yue <l@damenly.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Su Yue <glass.su@suse.com>, fstests@vger.kernel.org,
 linux-bcachefs@vger.kernel.org, l@damenly.org
Subject: Re: [PATCH] fstests: introduce MKFS_BCACHEFS_PROG for bcachefs
Date: Wed, 17 Jan 2024 10:46:01 +0800
In-reply-to: <ZaaGkadipvNY02HM@bfoster>
Message-ID: <le8o65d2.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org


On Tue 16 Jan 2024 at 08:37, Brian Foster <bfoster@redhat.com> 
wrote:

> On Sun, Jan 14, 2024 at 12:41:20PM +0800, Su Yue wrote:
>> mkfs.bcachefs supports force overwrite when option '-f' is 
>> given:
>> $ mkfs.bcachefs --help | grep force
>>   -f, --force
>> After this commit, MKFS_BCACHEFS_PROG will contains ' -f' so
>> we don't have to add '-f' to $MKFS_OPTIONS manually.
>>
>> It also fixes generic/466 which unsets MKFS_OPTIONS causing
>> that test hangs in mfks.bcachefs waiting for confirmation of
>> the force overwrite.
>>
>
> This seems mostly reasonable to me, but I'm kind of wondering 
> why I
> haven't had to add -f to my MKFS_OPTIONS for bcachefs. Is there
> something unique to the test environment that affects this? 
> I.e., I
> don't see any issue with generic/466 on a recent Fedora, even if 
> I
> pre-format the scratch dev with XFS.
>

I was running tests of group auto. There are some tests which
call _scratch_mkfs multiple times e.g. tests/generic/171.
Without '-f' in MKFS_OPTIONS, thoese tests hangs.
I will make it clearer in commit message.


--
Su
>> Signed-off-by: Su Yue <glass.su@suse.com>
>> ---
>>  common/config |  3 ++-
>>  common/rc     | 12 +++++++++---
>>  2 files changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/common/config b/common/config
>> index c9771ff934cb..1f9edceec57a 100644
>> --- a/common/config
>> +++ b/common/config
>> @@ -105,7 +105,7 @@ set_mkfs_prog_path_with_opts()
>>  	# Note: mkfs.f2fs doesn't support the --help option yet, 
>>  but it doesn't
>>  	# matter since it also prints the help when an invalid 
>>  option is given.
>>  	if [ "$p" != "" ] && \
>> -		$p --help |& grep -q "[[:space:]]-f[[:space:]|]"; then
>> +		$p --help |& grep -q "[[:space:]]-f[[:space:]|,]"; 
>> then
>>  		echo "$p -f"
>>  	else
>>  		echo $p
>> @@ -313,6 +313,7 @@ export MKFS_REISER4_PROG=$(type -P 
>> mkfs.reiser4)
>>  export E2FSCK_PROG=$(type -P e2fsck)
>>  export TUNE2FS_PROG=$(type -P tune2fs)
>>  export FSCK_OVERLAY_PROG=$(type -P fsck.overlay)
>> +export MKFS_BCACHEFS_PROG=$(set_mkfs_prog_path_with_opts 
>> bcachefs)
>>
>>  # SELinux adds extra xattrs which can mess up our expected 
>>  output.
>>  # So, mount with a context, and they won't be created.
>> diff --git a/common/rc b/common/rc
>> index cc92fe0681d6..f2e900bf1166 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -611,6 +611,9 @@ _test_mkfs()
>>      xfs)
>>  	$MKFS_PROG -t $FSTYP -- -f $MKFS_OPTIONS $* $TEST_DEV
>>  	;;
>> +    bcachefs)
>> +    $MKFS_BCACHEFS_PROG $MKFS_OPTIONS $* $TEST_DEV > /dev/null
>> +	;;
>>      *)
>>  	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* $TEST_DEV
>>  	;;
>> @@ -753,6 +756,10 @@ _scratch_mkfs()
>>  		mkfs_cmd="yes | $MKFS_PROG -t $FSTYP --"
>>  		mkfs_filter="grep -v -e ^mkfs\.ocfs2"
>>  		;;
>> +    bcachefs)
>> +		mkfs_cmd="$MKFS_BCACHEFS_PROG"
>> +		mkfs_filter="cat"
>> +		;;
>>  	*)
>>  		mkfs_cmd="yes | $MKFS_PROG -t $FSTYP --"
>>  		mkfs_filter="cat"
>> @@ -1044,7 +1051,7 @@ _scratch_mkfs_sized()
>>  		export MOUNT_OPTIONS="-o size=$fssize 
>>  $TMPFS_MOUNT_OPTIONS"
>>  		;;
>>  	bcachefs)
>> -		$MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS 
>> --fs_size=$fssize --block_size=$blocksize $SCRATCH_DEV
>> +		$MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize 
>> --block_size=$blocksize $SCRATCH_DEV
>
> Should this function have another bcachefs check at the top to 
> set
> def_blksize in the case the config specifies a blocksize to use?
>
> Brian
>
>>  		;;
>>  	*)
>>  		_notrun "Filesystem $FSTYP not supported in 
>>  _scratch_mkfs_sized"
>> @@ -1128,8 +1135,7 @@ _scratch_mkfs_blocksized()
>>  						-C $blocksize $SCRATCH_DEV
>>  		;;
>>  	bcachefs)
>> -		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS 
>> --block_size=$blocksize \
>> -								$SCRATCH_DEV
>> +		_scratch_mkfs --block_size=$blocksize
>>  		;;
>>  	udf)
>>  		_scratch_mkfs -b $blocksize
>> --
>> 2.43.0
>>
>>
