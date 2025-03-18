Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A694820E6E1
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 15:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742311210; cv=none; b=FLmBkRO60Tcu5MHy14GIswwLQHQI6ZtVnGBIIbUzd7h6Y28FNipP18DXotz+XxZDAZ6L1Hwl8EzWpbadhPmMhz/FnSWcHC6vH/HDlY8jn+R7nQ/elkGsiLk9ZZmxAe9Y0pexr/4JQXQhSiymgIW6q+mDv+HBPxD5SMRBmD2a3jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742311210; c=relaxed/simple;
	bh=bKFqxwrcatfLHNeID/WctBMcjQzfcBdVjyA5Rf8Syow=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=QU4oMtfI+mueBwusBLVrOVEAeCRnIuWjcWrw0FR0M4ZCuK3SDmRrBw0JmTx8bIKz6nuPJD6zLM4pHbHgfcac7zMrDpUDRvsO3QN8no88QS2tG0d3rJgeaDappPMTJkx2/sTUFpzrRgsT0T5kSy5p9u+NFBe/KBtNpPEQSYL6rAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LFjKJZOt; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LFjKJZOt"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-225477548e1so102350035ad.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 08:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742311208; x=1742916008; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DjYRvA7kXhCice+HMpJ/Dd+zB8feODJnmrJZJRqTWO4=;
        b=LFjKJZOtBhu2rVWd4h3rJ37WJIuDHlglIU/J4or85QOApJR451XaZPJKZnZ9QlVd4D
         Did7MZseCRGDI5q8oEH8JqWDC1dJnL9CQ5rKxxM31cH3VitME032wEFkqRKPug2ap9Yz
         a8+X1995RLJNpmejtzySEixJsrKwhSQ3x7/8iGetD5FGB6EQEl5WKTld+j1w3x4i8TlW
         ghK4nKmlYFWUAuKK3QA3z2orV0AlcwXJp0ZRhfUjX+le2oWS99i1Au1Kclc0CVl6Gdwg
         6BPTnfbnvSZKGeq/+fh6fndFctNhsrW30OKYIWCg6PRXa9usr03abeMn3IuNHqpx9gqI
         8JXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742311208; x=1742916008;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DjYRvA7kXhCice+HMpJ/Dd+zB8feODJnmrJZJRqTWO4=;
        b=TUYOEZMsQnNO+27G32XVRchvWatLLdmVpcPArXVGide5idBiECptEw9SO5tULfgnrL
         8dW4mD44GAnJFZERZdW7YRDcAnvrPyR5Ka0/lIMdYEovUFPDjheI+SaI/vcrZNvz4NVV
         swr/n9QlzzU5Sj83pZOapIon+zV9IILJ8pG3iOZy8bUAVn2gDoX/MP1SWaLFV9K94kNa
         Wboh6H4qaN0Dwez8kyFv2FAiyd5bEn/ak9jQkMoR4/8wr/288/JbsDkVvlGpnjERePdb
         wVfeanISW9pgKPNOZ8mH+4DaSxYqKnq5LLDGB7N17OsYY6Lm4SIVFkG0oCRc61D+SyoZ
         jDxg==
X-Forwarded-Encrypted: i=1; AJvYcCWj5XVIKLhaDhoT7kIddTskO5sNwmqMxdCJGGUbIgy15q4/pEeuH1WPNlMdToFUPBJagIVHXpkpGWcE39qm4w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyRwaTcaofbsFE1QzjktZ9jqDRG+d1JQM5O+xu2tqTg7b2lUFR+
	7YM9OGL27ZD357DnGY2MfYKoGQeBWOYOZcXAq0TVb7NE5QbdV1Tt
X-Gm-Gg: ASbGncsJDrquA5oYViQ+/G7vehC8HuL8jC/aCLGyziKvKLyb63yQKQiuUP3Sp0j6zsF
	DGfLl6WNAAt5ks3uYG4Z7JrUd/KJmQEQ51GmDuEthdu/Pt/dhhit8GJ9ZNDVvZUpo3Wcu/SuPQJ
	YVbVkbhjEbmszKR3PBI2NM5md+qnMHE0NBbACsZagjskTTJFOtYacNBoPsU6BmmZlo9JqA9kqzM
	+O8yn262mdSSiSiD6Iy8CGfyg7CpdYxScfH6lrsqNzlNg3vCaSln85xkPVxg++eqmdoAsqsfcdD
	Q1yxmDBc9LEdh+WHaoWN4Pb9TtSRI4UVPUW4i70=
X-Google-Smtp-Source: AGHT+IE2aqDjzmVWKnjFD1XSYuV//din0taWgjBAlVJxVCkM2r6syQaZkrbGoNLUEpxYIx4IO+R38Q==
X-Received: by 2002:a17:902:db05:b0:220:d439:2485 with SMTP id d9443c01a7336-225e0a8ea60mr196023875ad.29.1742311207694;
        Tue, 18 Mar 2025 08:20:07 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6bd5d97sm95592675ad.259.2025.03.18.08.20.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Mar 2025 08:20:07 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH] bcachefs: Increase blacklist range
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <gogyhxsomty6ooldwglk36qa2rqn6iwwwhopslmui2k3naky2i@4vzz3myybst5>
Date: Tue, 18 Mar 2025 23:19:52 +0800
Cc: John Stoffel <john@stoffel.org>,
 linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <482110E9-C91B-4E34-9B42-0D12616C2EBC@gmail.com>
References: <20250315073942.1909895-1-mmpgouride@gmail.com>
 <26584.36082.936426.143774@quad.stoffel.home>
 <gchq6w4tyrx4wxjepyfoerprnsp3jlzm2acel4hfaf4z3jp4iw@53mpn6u5edc7>
 <26585.33403.270413.729999@quad.stoffel.home>
 <gogyhxsomty6ooldwglk36qa2rqn6iwwwhopslmui2k3naky2i@4vzz3myybst5>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3826.400.131.1.6)

On Mar 18, 2025, at 22:57, Kent Overstreet <kent.overstreet@linux.dev> =
wrote:
>=20
> On Tue, Mar 18, 2025 at 10:26:03AM -0400, John Stoffel wrote:
>>>>>>> "Kent" =3D=3D Kent Overstreet <kent.overstreet@linux.dev> =
writes:
>>=20
>>> On Mon, Mar 17, 2025 at 04:58:26PM -0400, John Stoffel wrote:
>>>>>>>>> "Alan" =3D=3D Alan Huang <mmpgouride@gmail.com> writes:
>>>>=20
>>>>> Now there are 16 journal buffers, 8 is too small to be enough.
>>>>> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
>>>>> ---
>>>>> fs/bcachefs/recovery.c | 2 +-
>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>=20
>>>>> diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
>>>>> index 71c786cdb192..a6e26733854d 100644
>>>>> --- a/fs/bcachefs/recovery.c
>>>>> +++ b/fs/bcachefs/recovery.c
>>>>> @@ -899,7 +899,7 @@ int bch2_fs_recovery(struct bch_fs *c)
>>>>> * journal sequence numbers:
>>>>> */
>>>>> if (!c->sb.clean)
>>>>> - journal_seq +=3D 8;
>>>>> + journal_seq +=3D JOURNAL_BUF_NR * 4;
>>>>=20
>>>> Instead of magic numbers, could you put in a define with an
>>>> explanation of how you arrived at this number?  Just to document =
the
>>>> assumptions better?
>>>>=20
>>>> John
>>=20
>>> The * 4 is a fudge factor.
>>=20
>> Ok.
>>=20
>>> But actually, I was giving this more thought and I don't think we =
have
>>> the correct number.
>>=20
>> We have a WAG here.  :-)
>>=20
>>> The real bound is "number of unflushed journal entries that might =
have
>>> been allocated, and have other items (btree nodes) referring to that
>>> sequence number, but which don't hit because beacuse they weren't
>>> flushed".
>>=20
>>> And we don't have an actual bound on that.
>>=20
>> So what happens if journal_seq overflows?  I don't know the code and
>> haven't looked.  =20
>=20
> In the olden days, in the before times, blacklisting insufficient
> sequence numbers would mean btree node entries could become visible
> after a crash that should've been ignored, because they were newer =
than
> the newest (flush) journal entry.
>=20
> That can't happen anymore because pointers to btree nodes now indicate
> how many sectors we've written and completed within that node, and
> they're updated after every btree node write (log append).
>=20
> IOW - our mechanism for sequential consistency now is that the b-tree
> behaves like a pure COW btree.
>=20
> So I retract what I said before :) Having just checked the journal =
read
> path, and the recovery path that creates the blacklist entries, I =
think
> we're good.
>=20
> The only reason we'd need to blacklist more is if we want some kind of =
a
> double check on the modern sequential consistency mechanism, and I =
don't
> think we need that.

What about multi-btree sequential consistency ?

i.e. one btree completes the entire tree update, but the other doesn=E2=80=
=99t



