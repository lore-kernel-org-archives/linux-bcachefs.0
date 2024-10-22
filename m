Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF8083CD6;
	Tue, 22 Oct 2024 02:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729562459; cv=none; b=BoP6Mts+unyGjrvULpZ+fSbmpxkwC7PaeLkFPLJIntSvrIycuq1RX+EwzzTIDVD837aJk/f18+V1odjEEx64wAl7LJYmjYj1nQM4z/9vvZRO11uN/2oTXHFDxGesehrmRvX5iUgpbcWGyR9/QnJT+lzH0pJAaJY0xc04dswRT2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729562459; c=relaxed/simple;
	bh=kQK1Re3ZgQEEXEdfeHfZBw2YULtsSH5KlE9GvVpFH6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=mvIff7MpDIg83tqlKW+4MERP08Jh2NEpiCsrG09ChkD+vYY+Yoma3/Fs0EYFtR5WO1kdsgYWfmf9UlQchOaLE5dD2e6ZueHMijUElmO+JzIeEFsmKF6jOLwcIC+8UweE6PFpRlbFKntWQcVhrIbISqiPRyS807UNsBBEBEV2weU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4XXZgm2LdYzQs4q;
	Tue, 22 Oct 2024 09:43:00 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id C78F61800DB;
	Tue, 22 Oct 2024 09:43:50 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 22 Oct 2024 09:43:50 +0800
Message-ID: <9ec25394-3d89-41b3-b62e-2d522cdc7319@huawei.com>
Date: Tue, 22 Oct 2024 09:43:49 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "bcachefs: Add asserts to
 bch2_dev_btree_bitmap_marked_sectors()"
Content-Language: en-US
To: <manas18244@iiitd.ac.in>, Kent Overstreet <kent.overstreet@linux.dev>
CC: <linux-bcachefs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Anup
 Sharma <anupnewsmail@gmail.com>, Shuah Khan <skhan@linuxfoundation.org>,
	<syzbot+e8eff054face85d7ea41@syzkaller.appspotmail.com>
References: <20241021-revert-assert-bch2-v1-1-e869c7c55bb6@iiitd.ac.in>
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <20241021-revert-assert-bch2-v1-1-e869c7c55bb6@iiitd.ac.in>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)



On 2024/10/22 0:48, Manas via B4 Relay wrote:
> From: Manas <manas18244@iiitd.ac.in>
> 
> This reverts commit 60f2b1bcf519416dbffee219132aa949d0c39d0e.
> 
> This syzbot bug[1] is triggered due to the BUG_ON assertions added in
> __bch2_dev_btree_bitmap_mark. During runtime, m->btree_bitmap_shift is
> 63 '?'. This triggers both the assertions.
> 
> Reverting the commit does not reproduce the said bug.
> 
> [1] https://syzkaller.appspot.com/bug?extid=e8eff054face85d7ea41
> 
> Signed-off-by: Manas <manas18244@iiitd.ac.in>
> Reported-by: syzbot+e8eff054face85d7ea41@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e8eff054face85d7ea41
> ---
> This syzbot bug[1] is triggered due to the BUG_ON assertions added in
> __bch2_dev_btree_bitmap_mark. During runtime, m->btree_bitmap_shift is
> 63 '?'. This triggers both the assertions.
> 
> I am unfamiliar with the codebase, and there wasn't a lore discussion
> about the assertions in the commit, so I am unsure about the relevance
> of these assertions.
> 
> Reverting the commit does not reproduce the said bug.
> 
> [1] https://syzkaller.appspot.com/bug?extid=e8eff054face85d7ea41
> ---
>   fs/bcachefs/sb-members.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
> index fb08dd680dacf82bca414f424024e4a00bf432de..9790fd47338c46d2af30547e1f41a1e578b71aa4 100644
> --- a/fs/bcachefs/sb-members.c
> +++ b/fs/bcachefs/sb-members.c
> @@ -450,9 +450,6 @@ static void __bch2_dev_btree_bitmap_mark(struct bch_sb_field_members_v2 *mi, uns
>   		m->btree_bitmap_shift += resize;
>   	}
>   
> -	BUG_ON(m->btree_bitmap_shift > 57);
> -	BUG_ON(end > 64ULL << m->btree_bitmap_shift);
> -
May be this is not good way by just removing the BUG_ON. In my humble 
opinion, the former code have checked m->btree_bitmap_shift in 
bch2_dev_btree_bitmap_marked_sectors. May be add the similar condition 
in this helper will be better.

Thanks,
Hongbo

>   	for (unsigned bit = start >> m->btree_bitmap_shift;
>   	     (u64) bit << m->btree_bitmap_shift < end;
>   	     bit++)
> 
> ---
> base-commit: 42f7652d3eb527d03665b09edac47f85fb600924
> change-id: 20241021-revert-assert-bch2-25474fe809d1
> 
> Best regards,
