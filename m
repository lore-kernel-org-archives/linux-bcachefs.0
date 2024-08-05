Received: from andre.telenet-ops.be (andre.telenet-ops.be [195.130.132.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E886C149C45
	for <linux-bcachefs@vger.kernel.org>; Mon,  5 Aug 2024 08:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.132.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722846318; cv=none; b=Kw/30suROKJDufAdq14kjQaqhxCvG2kUbBFC4VAHMSYOdPghFLgzdDbKiuAeg1o/ScqyIl+E1ZnnRlWoQjhWL3gYH7edEykafD5WIXU6k6cuTQzknt4ZqV6L2ulrPzg1EmazAu3aho1zA2Ek40mEtBYciW3dWskB9It7hivuB9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722846318; c=relaxed/simple;
	bh=VWk3GzQiVwlHz+RIOESjxjmRhlhiomeDnmQZsYN0elg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=DUdaiPali+98LtAn+P1h+tem1Ln59eX7KQUjQMrt7yiPhZeRxf1EZO9Plxq3VBq3f/Vc6HnEhM7IChVJG/CRU8s78Oyej5KNzcFH2zk2cbcywmviDkGb5yBgCJbB+AnHJB4SP/WAkkiIv91RQSKBzjpiMrgX5N9Rj+EUQO+D2Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.132.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:23c7:e51f:c68a:b0e5])
	by andre.telenet-ops.be with bizsmtp
	id w8R82C00E4yPHVg018R8o2; Mon, 05 Aug 2024 10:25:08 +0200
Received: from geert (helo=localhost)
	by ramsan.of.borg with local-esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1sat1g-0050JL-9n;
	Mon, 05 Aug 2024 10:25:08 +0200
Date: Mon, 5 Aug 2024 10:25:08 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
cc: linux-bcachefs@vger.kernel.org, intel-xe@lists.freedesktop.org, 
    dri-devel@lists.freedesktop.org
Subject: Re: Build regressions/improvements in v6.11-rc2
In-Reply-To: <20240805080012.239408-1-geert@linux-m68k.org>
Message-ID: <f02ec5a4-2918-24e3-8683-f965e2139830@linux-m68k.org>
References: <CAHk-=wh01xPAWUT_=J1TehFOu3SST12UTNuB=QQTeRw+1N4pDQ@mail.gmail.com> <20240805080012.239408-1-geert@linux-m68k.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 5 Aug 2024, Geert Uytterhoeven wrote:
> JFYI, when comparing v6.11-rc2[1] to v6.11-rc1[3], the summaries are:
>  - build errors: +9/-4

   + /kisskb/src/fs/bcachefs/data_update.c: error: the frame size of 1032 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]:  => 338:1

m68k-gcc8/m68k-allmodconfig

   + /kisskb/src/include/linux/compiler_types.h: error: call to '__compiletime_assert_950' declared with attribute error: FIELD_GET: mask is not constant:  => 510:38
   + /kisskb/src/include/linux/compiler_types.h: error: call to '__compiletime_assert_951' declared with attribute error: FIELD_GET: mask is not constant:  => 510:38

In function 'decode_oa_format.isra.26',
     inlined from 'xe_oa_set_prop_oa_format' at /kisskb/src/drivers/gpu/drm/xe/xe_oa.c:1664:6:

powerpc-gcc5/powerpc-all{mod,yes}config
powerpc-gcc5/ppc64le_allmodconfig

Seen before, fix available

   + {standard input}: Error: displacement to undefined symbol .L142 overflows 8-bit field :  => 1070
   + {standard input}: Error: displacement to undefined symbol .L161 overflows 8-bit field :  => 1075
   + {standard input}: Error: pcrel too far: 1397 => 1059, 1254, 1060, 1061, 1255
   + {standard input}: Error: unknown pseudo-op: `.al':  => 1270
   + {standard input}: Error: unknown pseudo-op: `.l18':  => 1111
   + {standard input}: Error: unknown pseudo-op: `.siz':  => 1273

sh4-gcc13 crickets

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
