Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E46516A92E
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Oct 2024 13:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729605555; cv=none; b=h2Ke4LNSpIEsIWUXdZb1yW0F10GCJS1w0Io1pZRwNZ3QhmS/SnGCt2TXZlqq1IzF55Y2bJHFNZ5VnugtP1+HfSrCsfE6FB4mitx4J/rmd1XYUcaErm3RjMewDh2H1uBqkQO5oMUyou6HrR3OM5PGuPt9z5mPHANeg+M0oxtvPiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729605555; c=relaxed/simple;
	bh=DTSva1rdvle9rEOtFTrkRxClj8575m9lPIDOzsRbJ3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fCfYYh0dm1qVndNHneUYd+/DFBRHYw9oV1k1tUnc9dS6wdkkferfQnTFg6XAuT8vAeMIy+X2sTfkyIs2z/PxqBQzRDQpuDSgjb4m6EjIAAS6bK4iAY8i5q6lOX7I6na5Ij22nSp6unmN5T08c6qbhOKj/FrQdAGCAcf3SNa0aDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iiitd.ac.in; spf=pass smtp.mailfrom=iiitd.ac.in; dkim=pass (1024-bit key) header.d=iiitd.ac.in header.i=@iiitd.ac.in header.b=UMgJLlvm; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iiitd.ac.in header.i=@iiitd.ac.in header.b="UMgJLlvm"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-20e576dbc42so40650625ad.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 22 Oct 2024 06:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iiitd.ac.in; s=google; t=1729605550; x=1730210350; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AE1/S8Ag+DpltPPDbeSO11HJbF7pe5vny3HkFSWRggA=;
        b=UMgJLlvmuQB4oAXP7Y0EdzqFaqQPTOJC5+jgVEAWyZSD3Kg183cUL3b3Yet/bjbqMj
         tAkK4iRktlqxgsYXU+AmMnB03Zi+7p+mHe5QIF9RdREaTZfGoDmiI16kSSNTdggfepQ9
         123DnjmLBPAOAk+ikXptEhRJXdA0cM37lABTM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729605550; x=1730210350;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AE1/S8Ag+DpltPPDbeSO11HJbF7pe5vny3HkFSWRggA=;
        b=Mv8FSr3cLKZHqK3PtBj70UDdXsJLmbdC/w4a0iacl/A5QEzfkSiQ5rNOe1huGaR4J3
         ZKa/XD3zn59MFoI7NtEEKPlf254YDxPipBbEgFUXChGcwjm0pRZECr/mMiMyJJtIpusy
         IalXJxNSXfKQPf0icSgvJvFoNxKUtoAF14hy65TW2quAXBpsiCxN2IatJ6GlZoBDyAGN
         NGhotoU6PwvRUC0tu2dVfShbLe3pUNyCD47oWg7Az/Ey2uvPAcau55qRu76eH2o87Mtr
         +RuRjdyEsWWD0rZVPW/B7ybpKQ/TIEffF/vcB2tvDRNYiEV7+tZedI7uKAK90wc4v4Z0
         mnfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcPSv/vaaknr6DrhZnruh+xIVrVVpBePEbnTaS264m8AT3WPvGnD49VJEisfE+3iNGRr5iEsDW4NLrWa4bMQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxS91bQ7TylinpPhG1uXcx9PpGl5MOn0Une703G0VUeyEayKEtF
	kYKMEIl0ESi4JzF+M9U0mHaPvlrRUXLy/6NXtoyZcl7FAX2iow+qoPQdRQ3XYig=
X-Google-Smtp-Source: AGHT+IE3cStKJ14M6UyhkDM72HyPZvjtoDBt5iaFcTvLq+3WsoQSeAog08b6B4C5Az7aChT6eiQgMA==
X-Received: by 2002:a17:902:f541:b0:20c:e169:eb75 with SMTP id d9443c01a7336-20e983f00efmr28705215ad.2.1729605550457;
        Tue, 22 Oct 2024 06:59:10 -0700 (PDT)
Received: from fedora ([103.3.204.148])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7eee6396sm43106995ad.16.2024.10.22.06.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 06:59:09 -0700 (PDT)
Date: Tue, 22 Oct 2024 19:29:02 +0530
From: Manas <manas18244@iiitd.ac.in>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Anup Sharma <anupnewsmail@gmail.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	syzbot+e8eff054face85d7ea41@syzkaller.appspotmail.com
Subject: Re: [PATCH] Revert "bcachefs: Add asserts to
 bch2_dev_btree_bitmap_marked_sectors()"
Message-ID: <d56wz2z6qne7lym3nidzb36yal25cmnaebjw6mkrz4lykw7ntz@jw6xsbveq227>
References: <20241021-revert-assert-bch2-v1-1-e869c7c55bb6@iiitd.ac.in>
 <9ec25394-3d89-41b3-b62e-2d522cdc7319@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <9ec25394-3d89-41b3-b62e-2d522cdc7319@huawei.com>

On 22.10.2024 09:43, Hongbo Li wrote:
>On 2024/10/22 0:48, Manas via B4 Relay wrote:
>>From: Manas <manas18244@iiitd.ac.in>
>>
>>This reverts commit 60f2b1bcf519416dbffee219132aa949d0c39d0e.
>>
>>This syzbot bug[1] is triggered due to the BUG_ON assertions added in
>>__bch2_dev_btree_bitmap_mark. During runtime, m->btree_bitmap_shift is
>>63 '?'. This triggers both the assertions.
>>
>>Reverting the commit does not reproduce the said bug.
>>
>>[1] https://syzkaller.appspot.com/bug?extid=e8eff054face85d7ea41
>>
>>Signed-off-by: Manas <manas18244@iiitd.ac.in>
>>Reported-by: syzbot+e8eff054face85d7ea41@syzkaller.appspotmail.com
>>Closes: https://syzkaller.appspot.com/bug?extid=e8eff054face85d7ea41
>>---
>>This syzbot bug[1] is triggered due to the BUG_ON assertions added in
>>__bch2_dev_btree_bitmap_mark. During runtime, m->btree_bitmap_shift is
>>63 '?'. This triggers both the assertions.
>>
>>I am unfamiliar with the codebase, and there wasn't a lore discussion
>>about the assertions in the commit, so I am unsure about the relevance
>>of these assertions.
>>
>>Reverting the commit does not reproduce the said bug.
>>
>>[1] https://syzkaller.appspot.com/bug?extid=e8eff054face85d7ea41
>>---
>>  fs/bcachefs/sb-members.c | 3 ---
>>  1 file changed, 3 deletions(-)
>>
>>diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
>>index fb08dd680dacf82bca414f424024e4a00bf432de..9790fd47338c46d2af30547e1f41a1e578b71aa4 100644
>>--- a/fs/bcachefs/sb-members.c
>>+++ b/fs/bcachefs/sb-members.c
>>@@ -450,9 +450,6 @@ static void __bch2_dev_btree_bitmap_mark(struct bch_sb_field_members_v2 *mi, uns
>>  		m->btree_bitmap_shift += resize;
>>  	}
>>-	BUG_ON(m->btree_bitmap_shift > 57);
>>-	BUG_ON(end > 64ULL << m->btree_bitmap_shift);
>>-
>May be this is not good way by just removing the BUG_ON. In my humble 
>opinion, the former code have checked m->btree_bitmap_shift in 
>bch2_dev_btree_bitmap_marked_sectors. May be add the similar condition 
>in this helper will be better.
>
Hi Hongbo, thanks for reviewing this. I was unsure about the fix so I decided to
initiate the conversation by reverting. Yes, that makes sense. I am sending a
fresh patch adding that condition.

-- 
Manas
