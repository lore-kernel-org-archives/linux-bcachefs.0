Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1AA23ED70
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Feb 2025 12:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739880263; cv=none; b=ZJcbtlrtant6Us63zLQrdxX+UeIvjBUtEnRRJCINFVKnyhdAPL7TySM9xWVZPAYMonE018neiJOwWa7yhpz+ZATrSwx30K6uepDBJ6uc//JG1RqpzUlEhmkbtiuX+Qk4Ve/wKgGZzcRNB27e5ajI8AXrZcQGqrwHBqUVkE6YSf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739880263; c=relaxed/simple;
	bh=wu881dvGJbWnUdtDmqzOol0iR91mIhlZEp81EuKM/LY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=II8MsQIz11bY3+/ZmChL79DK8BI+5VR1LI9N0V0yjBv1Pr49tYtcNEtRUv7paVPLio5gwMhJt9rYLyGcjJsoAQcy4Lv05VLAkQtGAtQkf4CHqUul/KYvnnRDW8xjm/Pk6ceh3hrpqd9WIjKmjPZLtII6C7kbaIDpQ7eKwx7wEjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bHD1EYCA; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bHD1EYCA"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7c08b14baa9so273418085a.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 18 Feb 2025 04:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739880261; x=1740485061; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=03lxxJZdY0qY1H9+27KXzE4OIEbxf7DXqfOWVkwZzAM=;
        b=bHD1EYCAZ5jCZEVv43Uc0t+n1bizytPTOpdbA6L1fPQmnHK/7U9Z/dVBK+56+0jROL
         WTjq0Aw6D6XA84B0LVjQxHY0YEQfrjeupLgc9TZo7xy6ZtEHW1g1FieGidnp0djY1JfL
         groNhR1MXt3KleCWIva1yjmGxEYiLO26VxO0UadnVpRQ5MVKPb0wKmHdAbD2e42u1R8w
         UiSGc9DFNVyoglqEyGQjwmUS+lbPNoE9Pq9V488htNpvEQEX5K5XyGkX+eN7gTu/6rkN
         zHsieBX8gpQbhFXKxxirq88LlwnM9hM5xTz+MZ2XKFNh8NN8xiWQnzrU5rscxNez0Izq
         kP+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739880261; x=1740485061;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=03lxxJZdY0qY1H9+27KXzE4OIEbxf7DXqfOWVkwZzAM=;
        b=s2TAlHYF3dR8WzghRhILicktxqoR4cUjaHQSK8WrjvXfEEEQrfR9evLoM721e7+zAn
         SFNFb/GPpXOuZ3xHvmW0nZXCipiKL1BS6xcebzITk/Mqwj9pWV6uWKBNha0hZIK9Hpmf
         anX62qEK+EPTBVxRww1YB9OyV+iNuNS04tEOOvPqL+EpD3oy7Sh6ZjMdDuFKcC/DqQf4
         DSwqR4h0OUgmmi2imdq6xuehPThnQdRreoxppOSHbfcdi1QuhxCGQnZnAaPAoiRAppJo
         3gQ1VOj9OrIG/tA6H1VbnCUc7oCWw+0USbEn2dfnDdPonRvDhaEbX3HAeEc+CDZThMeF
         7s7g==
X-Gm-Message-State: AOJu0YwD0c0r26gR0/4ajwJjE2FRqa69FIT5Gty/lZw5oAMsEUbFa5Yr
	PvXCNWU1bE8bTOrba+h8PnOgr+2WKnNqYeI/iXFgof5GybPQZE44
X-Gm-Gg: ASbGncs0u6uhI6zPK4ivK5aAihGwHLYD0PZwBcS2bc54lLUgOkXQUGrd4GKZmiUSHcn
	AF7Yiv9jamMuTr9UwG5IvATHg8shswr+NsJuC7XZroETDuX422YiNjHmWoJIz0GRaNFf5NVx0j1
	sv8H4dfG4bO5EuYyMOQ6b9zF1SeGVLvqdrwsvmbKXFG+UtMqGSeXyBYJIwdz1wu4XjH0W2skkbi
	d4WbGNOAe68aMfKEmHamvv8PvfKIMxAQNsEeuy5aRBlpn3ougRuLqK8zNDZ/4JMuMkAha8D9M0=
X-Google-Smtp-Source: AGHT+IGHUOjsM2a2DpsJjlHQYlR9tFZREgcAehkRDvJ3Xdz2jCW+1VMV1qNw7E5ZMMjCHE6C9YaD2w==
X-Received: by 2002:a05:6214:5006:b0:6e4:4274:aaf8 with SMTP id 6a1803df08f44-6e66ccbc633mr184281016d6.17.1739880260819;
        Tue, 18 Feb 2025 04:04:20 -0800 (PST)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-471f70c4cf2sm15228051cf.22.2025.02.18.04.04.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Feb 2025 04:04:20 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH] bcachefs: Fix memmove when move keys down
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <20250218063757.265776-1-mmpgouride@gmail.com>
Date: Tue, 18 Feb 2025 20:04:03 +0800
Cc: linux-bcachefs@vger.kernel.org,
 ryncsn@gmail.com,
 akpm@linux-foundation.org,
 syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <2A6365D7-7054-42CA-A6AF-7B0A75CF9D66@gmail.com>
References: <20250218063757.265776-1-mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
X-Mailer: Apple Mail (2.3826.400.131.1.6)

Ignore this.


> On Feb 18, 2025, at 14:37, Alan Huang <mmpgouride@gmail.com> wrote:
>=20
> Reported-by: syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> ---
> fs/bcachefs/btree_io.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
> index e71b278672b6..0022529522f1 100644
> --- a/fs/bcachefs/btree_io.c
> +++ b/fs/bcachefs/btree_io.c
> @@ -997,7 +997,7 @@ static int validate_bset_keys(struct bch_fs *c, =
struct btree *b,
> 		}
> got_good_key:
> 		le16_add_cpu(&i->u64s, -next_good_key);
> -		memmove_u64s_down(k, bkey_p_next(k), (u64 *) =
vstruct_end(i) - (u64 *) k);
> +		memmove_u64s_down(k, (u64 *) k + next_good_key, (u64 *) =
vstruct_end(i) - (u64 *) k - next_good_key);
> 		set_btree_node_need_rewrite(b);
> 	}
> fsck_err:
> @@ -1259,7 +1259,7 @@ int bch2_btree_node_read_done(struct bch_fs *c, =
struct bch_dev *ca,
>=20
> 			i->u64s =3D cpu_to_le16(le16_to_cpu(i->u64s) - =
k->u64s);
> 			memmove_u64s_down(k, bkey_p_next(k),
> -					  (u64 *) vstruct_end(i) - (u64 =
*) k);
> +					  (u64 *) vstruct_end(i) - (u64 =
*) bkey_p_next(k));
> 			set_btree_bset_end(b, b->set);
> 			set_btree_node_need_rewrite(b);
> 			continue;
> --=20
> 2.47.0
>=20

