Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26333224;
	Sun,  8 Sep 2024 13:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725800768; cv=none; b=V/7YxQc2eulLyYYUGacMNnM/suOH7eR8WYsApKt2q/qiNFj3rW/r/aOes+IqaRLS5KIoueMMW6ejn1NXsMUP+dRedixOexQyrlS/v+f7nRRJwCesfLX/YzD0zc7rCQYZBjygbE0tcEQniIGATRpIXGe+9TvMdqY0DdDfP3+Hps8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725800768; c=relaxed/simple;
	bh=CaRVzvEevftBdvo1pGuwdOT3yTW/S0LOeUWgEWmRm0o=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=i+4t2c+7C8OIWBCtipod6el5XHKtxJmu8owP5wjoncxDXgxQ45n+19VfDx+jU2p+5p743hjgh2GSFmoRmlxsWw2ksDlvSEJ/fW6mtQoG+hwmaUhzFon3JxvDt2Vc+6KUnc5pwznx8T9gdQfojaIbMUZEzBIz1M+wj3MEVGjZcXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=ddt79ys/; arc=none smtp.client-ip=43.163.128.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="ddt79ys/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1725800756; bh=TOmiRb9kT4y40MPa249+aAJYNFmF4Q7BxFuTvX0qR/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ddt79ys/1AmJV0aQ0Td8cfDOgeLFtzk1jsFF6aTccEd8m9t8Pn7RtjpTsoFNzyMVq
	 bOlLLyn5SYk20zPrRyXTwuBzR3P5yrQKs8aSWpNE4b6Wzh4KXnRdIUZzVj+6JEV5st
	 9Zt3q4cxt3GWAEv6/UNxbz6YTcQvskytMJZKnYUY=
Received: from pek-lxu-l1.wrs.com ([111.198.224.50])
	by newxmesmtplogicsvrszc13-0.qq.com (NewEsmtp) with SMTP
	id EEA29A9D; Sun, 08 Sep 2024 20:59:42 +0800
X-QQ-mid: xmsmtpt1725800382t9n026mas
Message-ID: <tencent_6FF377237A096263A9C4469779777566C805@qq.com>
X-QQ-XMAILINFO: Mdc3TkmnJyI/Hjc/Q79dP+nhHR01LVthwLXtMFIRjJ/Txo6sSmj12AVdUd3qZG
	 wgZOB5BjoGR4WgcNnJceKNDvBXDRSUjoZhQq71wh4YMBMsWjcV6D5raF0dDhZjj+KTbAjEhBkrGr
	 N4n3kDlcdmOfRM07CLEceidAz5Vco2BL/uWZD823ip0voE8epT7qL1iM3+h30EQVKRGszyDgwK7h
	 hCeFSrEb4LQMGbn0pqyi7ty6y/2e3tE4y9c+ACqpKAC1Ngsq1hvu0PTWE+oXnD4MeuBOOG+VfuZA
	 oZqjkNTmLr0gUDdKLCGH2qDLL4k8vsr8FaDmEXyshQyXiMw2gHC64uLsvobbrW3qu1emqIWIqEXf
	 Jv1Tg9g/fL/oVoGWXnOo+EKIBoGKpCMwxP0H5YFlIWQBw3OKadNakJ43AA5g/FlqK3RCssvQSduv
	 HsqxyPneWtlldqfrKgdMQuo7rPTf+RMRzOp4jWSwzM8JM1Dm1icdKlom/2ua9hpVa60klnyBKa6g
	 hE4jNMAvLBZvrx6ihufZiBoSaqFjhahsjQPd+Naw2y3LiJJoZSiosTc2ow+9bFr7LuMKNRvdXG2W
	 nk4XXmVF2IxQ9DOjkZ/S9MR1a07V9PiSp9Mi0ILfwVXNtlv6bjbjLU+SA/AbV5G5rTB0vptMDR5B
	 twan1H0NFvUvR+Q1WxQCj+V0ikCDtqRePb/jXa1kTH5Nsw0Gw4ihsL5vk1EBEOn/46KJTjuRe/e0
	 epPx2V8YBYNCb9h9LhTnChq+N8pYM4UtRiIfr4ptFkIkBWIn2nae3kv5SSu4V7gxbFX2QN4URszg
	 QvyALBKJzmoPfjM56ZrcF/XM/UMgWwgl53t370xpU0e1/ZXLC76c5IsA0mTP661Nqbzy5In7omoB
	 ghDo4pyScg+NYXi3rjy2DavrK014VcyQDFctfSW3mX4jhGe/Ww29Z9g48F9FZGWbUcmZxaqGxlw3
	 bXTnDYFi4SBpQ2JVBllUR2NrTb1sEajZ8EcNFUoNTP7cphRilhEOOKiLyVfoh8
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
From: Edward Adam Davis <eadavis@qq.com>
To: kent.overstreet@linux.dev
Cc: eadavis@qq.com,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+064ce437a1ad63d3f6ef@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in member_to_text
Date: Sun,  8 Sep 2024 20:59:37 +0800
X-OQ-MSGID: <20240908125936.1839376-2-eadavis@qq.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <hqzhbzxbp3rjbal3z4kdwygvus76h22o2br3iwuzohgniivw5q@etyntoz75vyp>
References: <hqzhbzxbp3rjbal3z4kdwygvus76h22o2br3iwuzohgniivw5q@etyntoz75vyp>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 4 Sep 2024 15:39:37 -0400, Kent Overstreet wrote: 
> On Tue, Sep 03, 2024 at 10:13:02AM GMT, Edward Adam Davis wrote:
> > Because the value of m.btree_bitmap_shift is 69 in this case, it cause
> > shift-out-of-bounds in member_to_text.
> >
> > Add a check for btree_bitmap_shift in validate_member, when it bigger than 64
> > return -BCH_ERR_invalid_sb_members.
> > Simultaneously adjust the output mode of btree_bitmap_shift in member_to_text.
> >
> > #syz test
> >
> > diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
> > index 39196f2a4197..85a4245ea6a3 100644
> > --- a/fs/bcachefs/sb-members.c
> > +++ b/fs/bcachefs/sb-members.c
> > @@ -162,6 +162,12 @@ static int validate_member(struct printbuf *err,
> >  		return -BCH_ERR_invalid_sb_members;
> >  	}
> >
> > +	if (m.btree_bitmap_shift > 64) {
> 
> should be >=, no?
Yes, you are right, here should be "if (m.btree_bitmap_shift >= 64)"
> 
> > +		prt_printf(err, "device %u: too many big bitmap shift (got %u, max 64)",
> > +			   i, m.btree_bitmap_shift);
> > +		return -BCH_ERR_invalid_sb_members;
> > +	}
> > +
> >  	return 0;
> >  }
> >
> > @@ -245,8 +251,7 @@ static void member_to_text(struct printbuf *out,
> >  		prt_printf(out, "(none)");
> >  	prt_newline(out);
> >
> > -	prt_printf(out, "Btree allocated bitmap blocksize:\t");
> > -	prt_units_u64(out, 1ULL << m.btree_bitmap_shift);
> > +	prt_printf(out, "Btree allocated bitmap shift: %d\t", m.btree_bitmap_shift);
> >  	prt_newline(out);
> >
> >  	prt_printf(out, "Btree allocated bitmap:\t");

BR,
Edward

