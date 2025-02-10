Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00ED8256C8E
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Feb 2025 17:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739206966; cv=none; b=k34DWhziMV1Q7sFaFW+PK8IpENF8XQJubH1IskF6aTeBBjrxhdu6sCjaAG/dMvLVYfQrBV/Ii9Wi1fZkBA4QK8I3dPCGwd5C0qlBfBd4wZ7CRdru3pK0BIwu/soPo6gcjwRygipmrHOcLo0A914/H4ewuMovrF6AwL8d3MsLVUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739206966; c=relaxed/simple;
	bh=pHWck25TckIUZQ31j0bNmoDjN5gLs1rnk3eZytkfIkc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=b8Jy+y5EMZBkAk50AQgNCPFEIqYCUZmdLEr79JteBx5g9ygp4z2KbcSBgcZm/jCvLe5mqlvsJporxLJUet0Ylbptnkxme5yB/szkYAHwiV9jAERWeQHHgEhVv/YxATQPk1xx5boPaSXv256FQMvXPI92NdGe6Sss9Z0U40YYXAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ry74n96t; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ry74n96t"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7c060568959so94153885a.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Feb 2025 09:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739206964; x=1739811764; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H4J1CkqDXZKMCWx3J+FLoYNFt98pHCVpH2EQjq5OP6g=;
        b=Ry74n96tcKMjiPdpd+cQHW8QrQr1aKpeay5ipj6rOiGqH9gB9B+HWZqNxE+tjB7809
         f+h8jTGVTPfql5CsU15eMu3oE/IBdPe5jy9uD5FYBDFFezwYd6w9VwFZaqJJRiWnu8M1
         t89SaTWGIQh1DRGm9SFQEvBZCf++4IerBlTss4QbzB+umbkM/uMqghi8pXo5sb5fkWfb
         hSguGIiHtl8afpbaQfL4nLAqWq8/Et+SKdkLxgtDNY6bYVQHSChmyzXKlZWJL37FrF/R
         G3GGnWZJZ5JVYnxd5UTjFLz7Y6SUTH+o17ksB6k4kDfAIPvaeNi57+Bzyd8jGMZvcNkY
         VUeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739206964; x=1739811764;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H4J1CkqDXZKMCWx3J+FLoYNFt98pHCVpH2EQjq5OP6g=;
        b=kEPcKcbo9vQQEc+Yuuhi6RUeOFHvSD0FwO/JRLFReI4wXvIf6roGGJg9Gphr6K6r6m
         IHetXMbUN6T9gh7guyB6OXkZ8vpLD0vFA7iZDIZLmsZQMmSudqRd9XE+64wJHvk9HDQ1
         90L8qm6X+VfP/+gMU4W12pFFbWPOUtk0/7ldo6Rm6zHyCFvA2ENRlabqPXq+AS/hBr3P
         pKS8r6MYHU3x9l7zvDAGJTVhY9U+lKU0DzXA3qmCFwAqC+gMx30NTRBD/9nC7QVTMT8E
         34pSazcJC4KR/F+3UW+qC+DwTC0KEpkwLtzZ8glC3thRv50gHkZe11A+03dZLjmxjBuR
         5Qaw==
X-Gm-Message-State: AOJu0YxBwTqfLMuadaHQslnj7jOt+hFKlvEjqj0oArEQPz0aETRP3bj4
	/VIE7jzDuq8c9WTQUpL0oMt9VLHzsXuw3waGvytL98ap58H3UHll
X-Gm-Gg: ASbGnctq5gSbhKzrwF7wpFq82aPGCZTMI6+NWCCGck7NMBmS89yu6ZUXwY3rKTJuFJY
	7bnswnhm560fyxWva5F+Iksh+2k9WJC0PM4XXqTijR/jtlnfXBk/0nVpR5dQSM+adWwhAFSquPg
	UU+qG1lyLRzO+BOpXoA+3QkKtMpad38dZ+upzq0zIoxHUJQ9OBhPoeayYe4b40weG4Lg/+DQvS8
	EUmSJ4am8IKK+TUhzuTgGiBBxZkZGhMv7BLbsL68mhvxP1gM8YBDGSbQwXQfrFXgFC/OnMyGaA=
X-Google-Smtp-Source: AGHT+IEWAXegJkV/1kljJAUWQH6/pK2NAvs0nVWpAb3hzeWfVO9i/auBxOBR0zuC/afypFWqJUnsLA==
X-Received: by 2002:a05:620a:4448:b0:7c0:b82:8f90 with SMTP id af79cd13be357-7c047c2139amr2233502385a.35.1739206963697;
        Mon, 10 Feb 2025 09:02:43 -0800 (PST)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c0614f3c8bsm97064985a.55.2025.02.10.09.02.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Feb 2025 09:02:43 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH] bcachefs: Use uncompressed_size as the operand
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <sspfmyovbhs3d5a66cs7eau3xxkiebtvjhff3kw7iauzwhnn2y@e2f4wklauoiw>
Date: Tue, 11 Feb 2025 01:02:28 +0800
Cc: linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2423B2FF-40A3-4E4A-A254-E049431306A8@gmail.com>
References: <20250210030422.711912-1-mmpgouride@gmail.com>
 <sspfmyovbhs3d5a66cs7eau3xxkiebtvjhff3kw7iauzwhnn2y@e2f4wklauoiw>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3826.400.131.1.6)

On Feb 11, 2025, at 00:25, Kent Overstreet <kent.overstreet@linux.dev> =
wrote:
>=20
> On Mon, Feb 10, 2025 at 11:04:21AM +0800, Alan Huang wrote:
>> Since we don't merge compressed extents, uncompressed_size should be
>> equal to compressed_size, use uncompressed_size to clarify the =
intention.
>=20
> compressed_size actually describes the intention better here, it =
refers
> to size ondisk, and we're checking if the extents are contiguous on =
disk

But we don=E2=80=99t merge compressed extents.

There is is_compressed check above (below compressed_size check in the =
past as the history says)

Not sure if it=E2=80=99s my problem, but I spent hours before figuring =
out that we're checking if the extents are contiguous on disk.

>=20
>>=20
>> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
>> ---
>> fs/bcachefs/extents.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
>> index 05d5f71a7ca9..eeea23d09b9a 100644
>> --- a/fs/bcachefs/extents.c
>> +++ b/fs/bcachefs/extents.c
>> @@ -326,7 +326,7 @@ bool bch2_extent_merge(struct bch_fs *c, struct =
bkey_s l, struct bkey_s_c r)
>>    !bch2_checksum_mergeable(lp.crc.csum_type))
>> return false;
>>=20
>> - if (lp.crc.offset + lp.crc.live_size !=3D lp.crc.compressed_size ||
>> + if (lp.crc.offset + lp.crc.live_size !=3D lp.crc.uncompressed_size =
||
>>    rp.crc.offset)
>> return false;
>>=20
>> --=20
>> 2.47.0
>>=20

