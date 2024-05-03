Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC578495
	for <linux-bcachefs@vger.kernel.org>; Fri,  3 May 2024 16:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714753904; cv=none; b=WxSLMxQp5jaZ0UeGRP+ukG6Xgd2CWg1ekM790nC8AIjWJQ+w/E1Ezmz/snh6yWb1ukcDulsZpEL1Rt/nNBegi0bpahSFWPk5ASqFhspZESKfUcWoa2pA6XbHPhwbfw6IjuTccLiyu0lCcK1cl4zYwwc0JOl3na4Ec1vDnwTEQVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714753904; c=relaxed/simple;
	bh=rri2cPjmkVosOyUqnByvQgiwaiFhMshX8ptTgCTmEzQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XXxOcU5ZDlTuRcl2InT9CAj6IwbbzAGNQo/QgPZZJG2pL/pH7I1Kr2JiNTIdB1cbi5+2W/G6L5rjlZF6BYScgtjO3n6DrLoQw6VNakubHI9TZRaZ9O6eskfk0YsY0LskLG8ybbY/Ant5cqZGtNOGtPg06M+dowIvw+gvFImo+kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qADUesBM; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qADUesBM"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1ec76185cb3so215195ad.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 03 May 2024 09:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714753902; x=1715358702; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rri2cPjmkVosOyUqnByvQgiwaiFhMshX8ptTgCTmEzQ=;
        b=qADUesBMmW8PZESYprKTHCvtQp7St+rnUf+YvK97Tmfwzi6rCnyepWoOCaUXiGRAMW
         x0A401B2o0qAAo5VGumZB8T8OMmAb4KhTBcXd9+zhHkR8PbjIdDCXgPwlqimbhJaggbo
         WHaZK3DvRID0YybfrTtmky6UyCaWyhS/Jeuv2/kNdqCMl4PfiHIPOTa2bt91R4auEns2
         GzkpTJwwtH5EUt8Bl/St3sEF3OJkC+t0MEiYRDdy0Tp0FyuURwphtscY64W1/NpRp1Sx
         liCx19naRKfOrP4/XJ/a7YpGEOn9+GvjFv3BkLH+vwE1W8fJIY8ga1zw8f+F1+suNjEh
         aJwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714753902; x=1715358702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rri2cPjmkVosOyUqnByvQgiwaiFhMshX8ptTgCTmEzQ=;
        b=jzn3hPYk85Ic8JCR3Tt7wqWdSp90EiEIolxtHoB0JOoDm7BeHZC8eQ1WWZCXcQsBq4
         pme4GX8h8dOUq5BnPRer2vsKxwpym4LCdskhSp54Si4lZqo349X/fElo94ioMRY1DOLu
         U92mYjOEdKsracuI3ERlPcu+k1fXXlUxIfTyIa3DIBh36hd6PWmMn71azXyRmdCfL8sb
         QmHIDYWUC+sF5dwrXf8SO2ANwIB0Tlt4ypnQK2o7rUw7K7VzR7svY4P/vIfbsyK0xRyJ
         q2FoWH1ZHlzuIZAeFPHlpUL62OaGhrAnBueXZq/1zJhs/RXP9atv2eWJDhKtYsbrraHY
         GWBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBoxG/wAgCHn24+fqDOoq1ibCI9+y68RVkKA7zcHechYqQcW8DNL5qHylADBQ84J7LXiY5fYsXv3mfYSWvluw6zc+Q3dLyjmVwIgDcDzE=
X-Gm-Message-State: AOJu0Yy+8FwWAIYQRreinT/TAFIK0TY1GyxJzqJ/IHPCaFKP6VR7ooDu
	vbRdP8jYA1+YJTJvueYQnlLR3WRS/lpcclTV8NiKWevve1M+SFBfP7Hz5TyyR4t0wjpnzkUOfcN
	bJQc5DGOc8HUhRn2alaWJXq1TzJes1LP38vXk
X-Google-Smtp-Source: AGHT+IFhm6pcppngNbwLtVggtSg3Sa5W30jEzCLucGnvEWiee0x2gPFqpyRqL32iAcd1rJFvPG3D3tL/cJecEibXqTw=
X-Received: by 2002:a17:902:f693:b0:1e2:a7ba:ce63 with SMTP id
 d9443c01a7336-1ed3698375emr2034945ad.15.1714753902181; Fri, 03 May 2024
 09:31:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <oxdwygzxpbpwxgl5v5hzaj7er6oxt2rlmaobkov4t23xqptqrn@gxi3nlapfini>
 <CACT4Y+ZEPWbJsYvWauog95yRFuzZmA=tK-uS+aDT-x=jnc3f7Q@mail.gmail.com>
 <aw5elbevdhwuqr7ecap6i5hepvkjbgs5xexq7nvu2yvuhh5bpb@tmyjcruysqjf>
 <CANp29Y5d3cp_YGfy-3bjJYsNfniXFjAm9WfOUVL5zwk=6weALg@mail.gmail.com>
 <CACT4Y+aNh4oBMpfPdNe7aAJT-hK9WPN5G47d1DN4NkH883OOdA@mail.gmail.com>
 <yg56oeewdosga5bemxyhku37deglpqjxz5ocg7asyeb2c75kap@5bas2aygiama>
 <CANp29Y6wQSb2Zn9Jujhzw4Mij77Nvfo4+2fkpY=ppJ6OCDE6Qw@mail.gmail.com> <d6wuvtwgp3z7v7fleewvw6fkjk6d5hpjqpp7p2bmiq5ocf5ib4@ap4iyuhzkpum>
In-Reply-To: <d6wuvtwgp3z7v7fleewvw6fkjk6d5hpjqpp7p2bmiq5ocf5ib4@ap4iyuhzkpum>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 3 May 2024 18:31:30 +0200
Message-ID: <CANp29Y70mqP+4m_OmwORqKVk1hDHBwiZSvV43=nABa9pjMp7dA@mail.gmail.com>
Subject: Re: syzbot for bcachefs?
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com, 
	Thomas Bertschinger <tahbertschinger@gmail.com>, Ariel Miculas <ariel.miculas@gmail.com>, 
	linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 3, 2024 at 5:36=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Thu, May 02, 2024 at 10:28:42PM +0200, Aleksandr Nogikh wrote:
> >
> > I think the problem was that I was trying to save the generated files
> > to a 9p filesystem (so that I could easily take them out of my VM).
> > But now I've set up a proper userspace image with the latest 6.9 RC
> > kernel and it worked fine.
> >
> > >
> > > > Also what would be a good sets of options to generate seed images?
> > > > We try to "sample" space of different images to create seeds. To gi=
ve
> > > > you an idea here is what we do for other file systems:
> > > > https://github.com/google/syzkaller/blob/af24b0505c748561efb50f1d03=
c824d6642f6c0b/tools/syz-imagegen/imagegen.go#L60-L516
> > >
> > > --encrypted --no_passphrase
> > > --compression=3Dlz4
> > > --no-checksum
> >
> > The mkfs.bcachefs tool that I installed does not know the
> > --no-checksum flag, so I used --data_checksum=3Dnone
> > --metadata_checksum=3Dnone instead. Does it mean the same thing?
>
> That's the correct flags, I did a brainfart on that one :)

Cool :)
I've deployed the changes to syzbot today and it has already reported
8 findings:
https://syzkaller.appspot.com/upstream/s/bcachefs

--=20
Aleksandr
