Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD8A28684
	for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 09:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727082340; cv=none; b=CzZzkXQ8OVerUhV0MhkOLZbaE6Vfuh4z/0VCqRuWPuoEnjvGQpPIYe/bfGOh807EJ0jRHpsaNIPt4QoURbixwCmCpgFCXn2Qu3ttLV1LzGZL9FmcUvyUSvYLzMWwxKkDada4ctlmx1FSfaDwIeGSzsSFK+7K4dy/vwq/K2IQOnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727082340; c=relaxed/simple;
	bh=KLioyO0gbcW4Zt06lvC8mTE7s96f4CQ/jv+bMLyNpDw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=iLI6wpuuKeI4FG+AMOlu9xd8pBlLwXEZD75nsD54Ai2UqfeLC0/F38lrO3vFu0BRjQuesJZrRDKlfHkwdf8IVMBwF+9GFjnCvsTnNXdPjh7fO4T6fE+bA3S5AlFg0qip7WaxL8ZYNBNgFqFQUCtJYIc2BLOaP8EuvKIDR/Tfco4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XBxps2Bc6zpWc3;
	Mon, 23 Sep 2024 17:03:01 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 5CC95140384;
	Mon, 23 Sep 2024 17:05:04 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 23 Sep 2024 17:05:04 +0800
Message-ID: <515cc2a3-4962-45f0-9e96-64ab9f56811f@huawei.com>
Date: Mon, 23 Sep 2024 17:05:03 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH resend v2] bcachefs: reject unknown mount options
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>, David Disseldorp
	<ddiss@suse.de>
CC: <linux-bcachefs@vger.kernel.org>, Martin Doucha <martin.doucha@suse.com>
References: <20240917013957.13353-1-ddiss@suse.de>
 <fiwda3johielxusg2ab73km7xo6f3skobw7c7rv3mc4g6epgtf@vo5urbm7nb6a>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <fiwda3johielxusg2ab73km7xo6f3skobw7c7rv3mc4g6epgtf@vo5urbm7nb6a>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/9/22 7:13, Kent Overstreet wrote:
> On Tue, Sep 17, 2024 at 01:39:57AM GMT, David Disseldorp wrote:
>> This is effectively a revert of commit 03ef80b469d5 ("bcachefs: Ignore
>> unknown mount options"), rebased atop commit 929d954330142 ("bcachefs:
>> use new mount API").
>>
>> Contrary to the 03ef80b469d5 commit message, unknown mount options do
>> result in failure on other filesystems such as xfs, btrfs, ext4, etc.
>>
>> Ignoring unknown options may result in unexpected behaviour: e.g. if
>> an application requires future-workload-specific-mount-option to work
>> and is run on a system without future-workload-specific-mount-option
>> kernel support, then it may fail without indication of the missing
>> kernel functionality.
>>
>> This reversion may cause failures for existing users reliant on the
>> ignore-unknown behaviour, but it should be bearable given bcachefs is
>> still flagged experimental.
>>
>> Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")
>> Reported-by: Martin Doucha <martin.doucha@suse.com>
>> Closes: https://bugzilla.opensuse.org/show_bug.cgi?id=1230065
>> Signed-off-by: David Disseldorp <ddiss@suse.de>
>> Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
> 
> I applied this and got some new failures in the CI - it seems something
> is broken in remount.
> 
> 00162 ========= TEST   ec_small
> 00162
> 00162 WATCHDOG 60
> 00163 bcachefs (857683e6-ef4f-41f5-abdd-dca191c38fff): starting version 1.12: rebalance_work_acct_fix opts=errors=panic,metadata_replicas=2,data_replicas=2,erasure_code
> 00163 bcachefs (857683e6-ef4f-41f5-abdd-dca191c38fff): initializing new filesystem
> 00163 bcachefs (857683e6-ef4f-41f5-abdd-dca191c38fff): going read-write
> 00163 bcachefs (857683e6-ef4f-41f5-abdd-dca191c38fff): marking superblocks
> 00163 bcachefs (857683e6-ef4f-41f5-abdd-dca191c38fff): initializing freespace
> 00163 bcachefs (857683e6-ef4f-41f5-abdd-dca191c38fff): done initializing freespace
> 00163 bcachefs (857683e6-ef4f-41f5-abdd-dca191c38fff): reading snapshots table
> 00163 bcachefs (857683e6-ef4f-41f5-abdd-dca191c38fff): reading snapshots done
> 00163 bcachefs (857683e6-ef4f-41f5-abdd-dca191c38fff): done starting filesystem
> 00163 1+0 records in
> 00163 1+0 records out
> 00163 1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.0115145 s, 91.1 MB/s
> 00163 bcachefs: bch2_parse_one_mount_opt() Bad mount option rwerrors
> 00163 Error: Invalid argument
> 00163 Error 1 at /host//home/testdashboard/ktest/tests/fs/bcachefs/ec.ktest 32 from: mount -o remount,ro /mnt, exiting
> 00163 Error 1 at /host/home/testdashboard/ktest/tests/prelude.sh 269 from: ( set -e; run_test $i ), exiting
> 00163
> 00163 ========= FAILED ec_small in 2s
> 
> The test is just doing
> mount -o remount,ro /mnt

ah, this is indeed a bug in show_options. It misses a comma when fill 
options buffer to seq. The following code should be added.

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index e774cb3e6b1a..79c3a650b714 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1927,7 +1927,7 @@ static int bch2_show_options(struct seq_file *seq, 
struct dentry *root)
  	bch2_opts_to_text(&buf, c->opts, c, c->disk_sb.sb,
  			  OPT_MOUNT, OPT_HIDDEN, OPT_SHOW_MOUNT_STYLE);
  	printbuf_nul_terminate(&buf);
-	seq_puts(seq, buf.buf);
+	seq_printf(seq, ",%s", buf.buf);

  	int ret = buf.allocation_failure ? -ENOMEM : 0;
  	printbuf_exit(&buf);


I will send this later. The test passed in my environment with this v2 
patch.

Thanks,
Hongbo

> 
> Thomas, this is likely something you introduced, think you could take a
> look?
