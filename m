Received: from mail-108-mta150.mxroute.com (mail-108-mta150.mxroute.com [136.175.108.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FFC1BF53
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 15:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="r538pPMf"
Received: from filter006.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta150.mxroute.com (ZoneMTA) with ESMTPSA id 18d12ed53cf0003727.004
 for <linux-bcachefs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Tue, 16 Jan 2024 15:39:19 +0000
X-Zone-Loop: d92ea34b61227e55d91f519d7d14cb96f09791c6a79e
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:In-reply-to:Date:Subject:Cc:To:
	From:References:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5MPRFxBAdp2mji6+KhAY2sibl9D57jbZPERiXUH50KI=; b=r538pPMfqshS8BCeSej+2oDPuh
	lenvhCQwzOr6M3ImoutBozN9YyqGkXC40C1xZkAVybULHMciZsddmc06pLPE4R4nNQyChT457BFU5
	EH3IgSJzuZIQWJgirNiaGFK7gd5GUVTogh7nRKHVP83bcofbJ0WMzN7CAoISKo3TTfp6DwBVCWp0u
	nqXAe/TvyhK7PaV2XBXphBm6XIQJZX8Dwbmm3t5BtAaY4EAbZNdTU36vuYPF/pHp5JKrkgv3u4k1P
	lcZzHGujZj4HKkvyk/JifX8/trz4B1mAO8xJZEX/j88MsHOiHdTTZCj4XREFywy4dUbbMpQ/koVqb
	C0GtLE/w==;
References: <20240114044120.140111-1-glass.su@suse.com>
 <ZaaGkadipvNY02HM@bfoster>
User-agent: mu4e 1.7.5; emacs 28.2
From: Su Yue <l@damenly.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Su Yue <glass.su@suse.com>, fstests@vger.kernel.org,
 linux-bcachefs@vger.kernel.org, l@damenly.org
Subject: Re: [PATCH] fstests: introduce MKFS_BCACHEFS_PROG for bcachefs
Date: Tue, 16 Jan 2024 23:20:44 +0800
In-reply-to: <ZaaGkadipvNY02HM@bfoster>
Message-ID: <sf2x5lxr.fsf@damenly.org>
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
My bad. Something wrong happend during my test process and caused
incorrect memory. fstests call wipefs to erase scratch dev first.
I will remove the descirption about the
'have to add '-f' to $MKFS_OPTIONS in next version.
>
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
Yeah. Will add it.

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
